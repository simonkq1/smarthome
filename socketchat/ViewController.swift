//
//  ViewController.swift
//  2018.06.26_1
//
//  Created by admin on 2018/6/26.
//  Copyright © 2018年 Simon Chang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var isStream: InputStream? = nil
    var outStream: OutputStream? = nil
    var jsonObject: [String:Any] = [:]
    var chatData: [[String:Any]] = []
    static var memberData: [String:String] = [:]
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var speakText: UITextField!
    @IBAction func sendBtn(_ sender: Any) {
        if let text = speakText.text, text != "" {
            let member = ViewController.memberData
            let account = member["account"] as! String
            let id = member["id"] as! String
            let rname = member["rname"] as! String
            let textData = """
                            {"account":\"\(account)\","id":\"\(id)\","rname":\"\(rname)\","text":\"\(text)\"}
                        """
            
            print("aaaa : \(textData)")
            send(textData)
            speakText.text = ""
            
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.separatorColor = UIColor.clear
        speakText.addTarget(self, action: #selector(sendBtn(_:)), for: .editingDidEndOnExit)
        
        //MARK:- --- socket連線 ---
        let _ = Stream.getStreamsToHost(withName: "simonhost.hopto.org", port: 5000, inputStream: &isStream, outputStream: &outStream)
//        let _ = Stream.getStreamsToHost(withName: "localhost", port: 5000, inputStream: &isStream, outputStream: &outStream)
        isStream?.open()
        outStream?.open()
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: Notification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
        
        DispatchQueue.global().async {
            self.receiveData(avaliable: { (data) in
                DispatchQueue.main.async {
                    if let _ = data {
                        let chatString = data!["string"] as! String
                        let chatSender = data!["sender"] as! String
                        let chatAccount = data!["account"] as! String
                        let chatId = data!["id"] as! String
                        let chatrName = data!["rname"] as! String
                        var strDate = Date()
                        if !chatString.contains("naflqknflqwnfiqwnfoivnqwilncfqoiwncionqwiondi120ue1902ue09qwndi12y4891y284!@#!@#!@ED,qwiojndjioqwndioclqn21#!@") {
                            
                            self.chatData.append(["sender":chatSender,"string":chatString,"date":Date(),"account":chatAccount,"id":chatId,"rname":chatrName])
                                    strDate = Date()
                                self.tableView.reloadData()
                                print(self.chatData)
                            
                        }
                    }
                }
            })
        }
        
        
    }
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
    
    override func viewDidAppear(_ animated: Bool) {
        print(ViewController.memberData)
//        DispatchQueue.global().async {
//            let noData = "naflqknflqwnfiqwnfoivnqwilncfqoiwncionqwiondi120ue1902ue09qwndi12y4891y284!@#!@#!@ED,qwiojndjioqwndioclqn21#!@"
//            let member = ViewController.memberData
//            let account = member["account"] as! String
//            let id = member["id"] as! String
//            let rname = member["rname"] as! String
//            while true{
//                sleep(15)
//                let textData = """
//                {"account":\"\(account)\","id":\"\(id)\","rname":\"\(rname)\","text":\"\(noData)\"}
//                """
//
//                self.send(textData)
//            }
//        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return chatData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let sender = chatData[indexPath.row]["sender"] as! String
        let string = chatData[indexPath.row]["string"] as! String
        let date = chatData[indexPath.row]["date"] as! Date
        print(string)
        print(chatData)
        cell.textLabel?.text = sender
        cell.detailTextLabel?.text = string
        tableView.separatorColor = UIColor.clear
        
        // Configure the cell...
        
        return cell
    }
    
    
    
    func receiveData(avaliable: (_ data: [String:Any]?) -> Void) {
        var buf = Array(repeating: UInt8(0), count: 1024)
        
        while true {
            if let n = isStream?.read(&buf, maxLength: 1024) {
                let data = Data(bytes: buf, count: n)
                do{
                    jsonObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String : Any]
//                    print(jsonObject)
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }


}

