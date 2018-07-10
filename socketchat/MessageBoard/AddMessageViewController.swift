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
    
    @IBAction func cancel(_ sender: Any) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func send(_ sender: Any) {
        let url = "http://simonhost.hopto.org/chatroom/insertGroupMessage.php"
        let title = (titleTextField.text) ?? ""
        let context = (contentTextField.text) ?? ""
        print(context)
        if contentTextField.text != "" {
            Global.postToURL(url: url, body: "title=\(title)&text=\(context)&member=2&sid=\(Global.selfData.id)") { (html, data) in
                print(data)
                switch html {
                case "0":
                    DispatchQueue.main.async {
                        self.view.endEditing(true)
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
