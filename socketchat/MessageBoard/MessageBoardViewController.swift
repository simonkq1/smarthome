//
//  MessageBoardViewController.swift
//  socketchat
//
//  Created by admin on 2018/7/9.
//  Copyright © 2018年 Simon Chang. All rights reserved.
//

import UIKit

class MessageBoardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var messageData: [[String:String]] = []
    var textLabel = UILabel()
    
    
    @IBAction func addMessageAction(_ sender: UIBarButtonItem) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "message_create_vc") as! AddMessageViewController
        vc.messageBoard_vc = self
        vc.status = "增加"
        
        self.present(vc, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        var timeOut: CGFloat = 0
        let _ = loadMessageList()
        while messageData == [], timeOut < 10 {
            timeOut += 1/10
            sleep(1/10)
        }
        
//        print(messageData)
        
        tableView.register(UINib(nibName: "MessageBoardTableViewCell", bundle: Bundle(identifier: "Simon-Chang.-socketchat")), forCellReuseIdentifier: "Cell")
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
    
    func loadMessageList() -> String {
        let url = "http://simonhost.hopto.org/chatroom/selectGroupMessage.php"
        var status: String = ""
        if let jsonURL = URL(string: url) {
            do {
                let data = try Data(contentsOf: jsonURL)
                if String(data: data, encoding: .utf8) != "noData" {
                    self.messageData = []
                    let jsonData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [[String:String]]
                    self.messageData = jsonData
                    status = "0"
                }else if String(data: data, encoding: .utf8) == "noData"{
                    
                    status = "1"
                    DispatchQueue.main.async {
                        self.tableView.addSubview(self.drawNoDataString(string: "你沒有任何留言\n\n 新增一個吧!!"))
                    }
                }else {
                    status = "3"
                }
                
            } catch {
                status = "2"
                print(error)
            }
        }
        return status
    }
    func drawNoDataString(string: String) -> UILabel {
        DispatchQueue.main.async {
            self.textLabel.frame = CGRect(x: self.view.center.x, y: self.view.center.y, width: 300, height: 200)
            self.textLabel.center = self.view.center
            self.textLabel.center.y = self.view.center.y  - 100
            self.textLabel.textColor = UIColor.black
            self.textLabel.alpha = 0.5
            self.textLabel.font = UIFont(name: "System", size: 100)
            //        textLabel.layer.borderWidth = 1
            self.textLabel.textAlignment = .center
            self.textLabel.numberOfLines = 0
            self.textLabel.text = string
        }
        
        return textLabel
        
    }
    
    
    func timeToNow(targetTime: String) -> String {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 8)
        let now = Date() + (60 * 60 * 8)
        
        let newTarget = dateFormatter.date(from: targetTime)
        let components = Calendar.current.dateComponents([.second], from: newTarget!, to: now).second
        
        if components! < 60 {
            return "剛剛"
        }else if components! >= 60, components! < 3600{
            let timecom = Calendar.current.dateComponents([.minute], from: newTarget!, to: now).minute as! Int
            return "\(timecom) 分鐘前"
        }else if components! >= 3600, components! < 86400{
            let timecom = Calendar.current.dateComponents([.hour], from: newTarget!, to: now).hour as! Int
            return "\(timecom) 小時前"
        }else if components! >= 86400{
            dateFormatter.dateFormat = "MM/dd aHH:mm"
            dateFormatter.pmSymbol = "下午"
            dateFormatter.amSymbol = "上午"
            let strdate = dateFormatter.string(from: newTarget!)
            return strdate
        }else {
            return "error"
        }
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MessageBoardTableViewCell
        let title = messageData[indexPath.row]["gtitle"] as! String
        let context = messageData[indexPath.row]["gtext"] as! String
        let date = messageData[indexPath.row]["gdate"] as! String
        let datetonow = timeToNow(targetTime: date)
        
        cell.titleLabel.text = title
        cell.contentLabel.text = context
        cell.bottom_left_label.text = datetonow
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "show_and_chat_vc") as! MessageAndChatViewController
        vc.messageData = messageData[indexPath.row]
        vc.message_board_vc = self
        DispatchQueue.main.async {
            self.show(vc, sender: self)
        }
        print(indexPath.row)
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.size.height / 4
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
