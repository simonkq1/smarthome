//
//  AddMessageViewController.swift
//  socketchat
//
//  Created by admin on 2018/7/9.
//  Copyright © 2018年 Simon Chang. All rights reserved.
//

import UIKit

class AddMessageViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var titleView: UIView!
    
    @IBOutlet weak var contentTextField: UITextView!
    var titleIsEditing: Bool = false
    var messageBoard_vc: MessageBoardViewController!
    var message_and_chat_vc: MessageAndChatViewController!
    var status: String = ""
    
    var messageData:[String:String] = [:]
    
    @IBAction func cancel(_ sender: Any) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func send(_ sender: Any) {
        self.view.endEditing(true)
        switch status {
        case "增加":
            let url = "http://simonhost.hopto.org/chatroom/insertGroupMessage.php"
            let titletext = (titleTextField.text) ?? ""
            let context = (contentTextField.text) ?? ""
            print(context)
            if contentTextField.text != "" {
                Global.postToURL(url: url, body: "title=\(titletext)&text=\(context)&member=2&sid=\(Global.selfData.id as! String)") { (html, data) in
                    print(data)
                    switch html {
                    case "0":
                        let apnsURL = "http://simonhost.hopto.org/cgi-bin/pushForNoteBook.cgi?message=\(context)"
                        let ur = URL(string: apnsURL)
                        do {
                            let _ = try String(contentsOf: ur!)
                        }catch{
                            
                        }
                        DispatchQueue.main.async {
                            self.view.endEditing(true)
                            self.messageBoard_vc.textLabel.alpha = 0
                            self.messageBoard_vc.loadMessageList()
                            self.messageBoard_vc.tableView.reloadData()
                            self.dismiss(animated: true, completion: nil)
                        }
                        break
                    default:
                        break
                    }
                }
            }
        case "編輯":
            let editURL = "http://simonhost.hopto.org/chatroom/updateGroupMessage.php"
            
            let gid = messageData["gid"] as! String
            let titletext = (titleTextField.text) ?? ""
            let context = (contentTextField.text) ?? ""
            print("AAA")
            print(titletext)
            print(context)
            print(gid)
            Global.postToURL(url: editURL, body: "text=\(context)&title=\(titletext)&gid=\(gid)") { (string, data) in
                if string == "0" {
                    DispatchQueue.main.async {
                        self.messageBoard_vc.loadMessageList()
                        self.messageBoard_vc.tableView.reloadData()
                        self.dismiss(animated: true, completion: nil)
                        self.message_and_chat_vc.navigationController?.popViewController(animated: false)
                    }
                }
            }
            
        default:
            break
        }
    }
    
    @IBAction func titleViewTapGesture(_ sender: UITapGestureRecognizer) {
        if titleIsEditing == false {
            titleTextField.becomeFirstResponder()
            titleIsEditing = true
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
        titleTextField.borderStyle = .none
        titleView.drawborder(width: 0.5, color: UIColor.black, sides: [.down, .up])
        switch status {
        case "增加":
            break
        case "編輯":
            titleTextField.text = messageData["gtitle"] as! String
            contentTextField.text = messageData["gtext"] as! String
        default:
            break
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        titleIsEditing = false

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
