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
    
    
    @IBAction func addMessageAction(_ sender: UIBarButtonItem) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "message_create_vc") as! AddMessageViewController
        vc.messageBoard_vc = self
        self.present(vc, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("load")
        // Do any additional setup after loading the view.
        var timeOut: CGFloat = 0
        let _ = loadMessageList()
        while messageData == [], timeOut < 10 {
            timeOut += 1/10
            sleep(1/10)
        }
        
        print(messageData)
        
        tableView.register(UINib(nibName: "MessageBoardTableViewCell", bundle: Bundle(identifier: "Simon-Chang.-socketchat")), forCellReuseIdentifier: "Cell")
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "message_to_popover" {
            let popctrl = segue.destination.popoverPresentationController
            let popview = segue.destination as! MessagePopoverViewController
            popview.message_vc = self
            if sender is UIButton {
                popctrl?.sourceRect = (sender as! UIButton).bounds
                popctrl?.permittedArrowDirections = .down
            }
            popctrl?.delegate = self
        }
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
                    let jsonData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [[String:String]]
                    self.messageData = jsonData
                    status = "0"
                }else if String(data: data, encoding: .utf8) == "noData"{
                    status = "1"
                    tableView.addSubview(drawNoDataString(string: "You Have No Message\n\n Add One Now!!"))
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
        let textLabel = UILabel(frame: CGRect(x: self.view.center.x, y: self.view.center.y, width: 300, height: 200))
        textLabel.center = self.view.center
        textLabel.center.y = self.view.center.y  - 100
        textLabel.textColor = UIColor.black
        textLabel.alpha = 0.5
        textLabel.font = UIFont(name: "System", size: 100)
//        textLabel.layer.borderWidth = 1
        textLabel.textAlignment = .center
        textLabel.numberOfLines = 0
        textLabel.text = string
        
        return textLabel
        
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
        cell.titleLabel.text = title
        cell.contentLabel.text = context
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "show_and_chat_vc") as! MessageAndChatViewController
        vc.messageData = messageData[indexPath.row]
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
