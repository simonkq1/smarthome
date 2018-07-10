//
//  MessageAndChatViewController.swift
//  socketchat
//
//  Created by admin on 2018/7/9.
//  Copyright © 2018年 Simon Chang. All rights reserved.
//

import UIKit

class MessageAndChatViewController: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var contextLabel: UILabel!
    @IBOutlet weak var contextViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var chatTextField: UITextField!
    var isStream: InputStream? = nil
    var outStream: OutputStream? = nil
    var jsonObject: [String:Any] = [:]
    var chatData: [[String:Any]] = []
    var contextHeight: CGFloat!
    
    var originY: CGFloat!
    var messageData: [String:String] = [:]
    var isLoaded: Bool = false
    var tableViewHeight:CGFloat = 0
    
    @IBAction func sendMessage(_ sender: Any) {
        if let text = chatTextField.text, text != "" {
            let sendURL = "http://simonhost.hopto.org/chatroom/insertChatMessage.php"
            let gid = messageData["gid"] as! String
            let sid = Global.selfData.id
            Global.postToURL(url: sendURL, body: "gid=\(gid)&sid=\(sid)&text=\(text)") { (html, data) in
                print(html)
            }
            let now = Date() + (60 * 60 * 8)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 8)
            let noeDate = dateFormatter.string(from: now)
            let chatTemp = ["text":text, "username":Global.selfData.username, "mid":sid, "account":Global.selfData.account, "sid":sid, "gid":gid, "date": noeDate]
            chatData.append(chatTemp)
            tableView.reloadData()
            
        }
        chatTextField.text = ""
        if chatData.count != 0 {
            scrollViewToBottom(animated: true)
        }
        self.view.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: "ChatTableViewCell", bundle: Bundle(identifier: "Simon-Chang.-socketchat")), forCellReuseIdentifier: "Cell")
        
        originY = self.view.frame.origin.y
        
        chatTextField.addTarget(self, action: #selector(sendMessage(_:)), for: .editingDidEndOnExit)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: Notification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: Notification.Name.UIKeyboardWillHide, object: nil)
        titleTextField.isEnabled = false
        titleTextField.borderStyle = .none
        titleTextField.isSelected = false
        titleView.layer.borderWidth = 0.5
        contextHeight = contextViewHeightConstraint.constant
        if contextViewHeightConstraint.constant < contextLabel.frame.size.height {
            contextViewHeightConstraint.constant = contextLabel.frame.size.height
        }
        messageLoad()
        loadChatData()
        while isLoaded == false {
            sleep(1/10)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    func messageLoad() {
        titleTextField.text = messageData["gtitle"]
        contextLabel.text = messageData["gtext"]
    }
    
    func loadChatData() {
        let url = "http://simonhost.hopto.org/chatroom/selectChatMessage.php"
        let gid = messageData["gid"] as! String
        
        let postURL = URL(string: url)
        var request = URLRequest(url: postURL!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30)
        request.httpBody = "gid=\(gid)" .data(using: .utf8)
        request.httpMethod = "POST"
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                let string = String(data: data, encoding: .utf8)
                
                if string != "noData", string != "error" {
                    do {
                        let jsonData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [[String:Any]]
                        self.chatData = jsonData
                        self.isLoaded = true
                        
                    }catch{
                        self.isLoaded = false
                    }
                }else if string == "noData" {
                    self.isLoaded = true
                }
                
            }else {
                self.isLoaded = false
            }
        }
        dataTask.resume()
    }
    
    
    func timeToNow(targetTime: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 8)
        let now = Date() + (60 * 60 * 8)
        
        let newTarget = dateFormatter.date(from: targetTime)
        let components = Calendar.current.dateComponents([.second], from: newTarget!, to: now).second
        if components! < 60 {
            return "just"
        }else if components! >= 60, components! < 3600{
            let timecom = Calendar.current.dateComponents([.minute], from: newTarget!, to: now).minute as! Int
            return (timecom != 1) ? "\(timecom) minutes ago" : "\(timecom) minute ago"
        }else if components! >= 3600, components! < 86400{
            let timecom = Calendar.current.dateComponents([.hour], from: newTarget!, to: now).hour as! Int
            return (timecom != 1) ? "\(timecom) hours ago" : "\(timecom) hour ago"
        }else if components! >= 86400{
            let timecom = Calendar.current.dateComponents([.day], from: newTarget!, to: now).day as! Int
            
            return (timecom != 1) ? "\(timecom) days ago" : "\(timecom) day ago"
        }else {
            return "error"
        }
    }
    
    //MARK: KeyBoardHeight
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= keyboardFrame.height
        }
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func scrollViewToBottom(animated: Bool) {
        self.tableView.scrollToRow(at: IndexPath(row: self.chatData.count - 1, section: 0), at: .bottom, animated: false)
        
    }
    
    //MARK: - TableViewControl
    
    func numberOfSections(in tableView: UITableView) -> Int {
        tableViewHeight = 0
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        self.tableView.frame.height =
        return chatData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ChatTableViewCell
//        tableViewHeight += tableView.rowHeight
//        tableView.frame.size.height = tableViewHeight
        
        let sender = chatData[indexPath.row]["username"] as! String
        let text = chatData[indexPath.row]["text"] as! String
        let date = chatData[indexPath.row]["date"] as! String
        let currentTime = timeToNow(targetTime: date)
        cell.contextLabel.text = text
        cell.nameLabel.text = sender
        cell.timeLabel.text = currentTime
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func heightForTableView() {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - SocketServer
    
    func socketServer() {
        
        let _ = Stream.getStreamsToHost(withName: "simonhost.hopto.org", port: 5000, inputStream: &isStream, outputStream: &outStream)
        //        let _ = Stream.getStreamsToHost(withName: "localhost", port: 5000, inputStream: &isStream, outputStream: &outStream)
        isStream?.open()
        outStream?.open()
        
        
        DispatchQueue.global().async {
            self.receiveData(avaliable: { (data) in
                DispatchQueue.main.async {
                    if let _ = data {
                        let chatString = data!["string"] as! String
                        let chatSender = data!["sender"] as! String
                        let chatAccount = data!["account"] as! String
                        let chatId = data!["id"] as! String
                        let chatrName = data!["username"] as! String
                        var strDate = Date()
                        if !chatString.contains("naflqknflqwnfiqwnfoivnqwilncfqoiwncionqwiondi120ue1902ue09qwndi12y4891y284!@#!@#!@ED,qwiojndjioqwndioclqn21#!@") {
                            
                            self.chatData.append(["sender":chatSender,"string":chatString,"date":Date(),"account":chatAccount,"id":chatId,"username":chatrName])
                            strDate = Date()
                            self.tableView.reloadData()
                            if chatId == Global.memberData["id"] {
                                self.scrollViewToBottom(animated: false)
                            }
                            
                            
                        }
                    }
                }
            })
        }
    }
    
    func receiveData(avaliable: (_ data: [String:Any]?) -> Void) {
        var buf = Array(repeating: UInt8(0), count: 1024)
        
        while true {
            if let n = isStream?.read(&buf, maxLength: 1024) {
                let data = Data(bytes: buf, count: n)
                do{
                    jsonObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String : Any]
                }catch{
                    print(error)
                }
                
                avaliable(jsonObject)
            }
        }
    }
    
    func send(_ string: String) {
        var buf = Array(repeating: UInt8(0), count: 1024)
        var data = string.data(using: .utf8)!
        
        data.copyBytes(to: &buf, count: data.count)
        outStream?.write(buf, maxLength: data.count)
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
