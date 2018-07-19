//
//  UpdateUserNameViewController.swift
//  socketchat
//
//  Created by Simon on 2018/7/19.
//  Copyright © 2018年 Simon Chang. All rights reserved.
//

import UIKit

class UpdateUserNameViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet var saveBarButtonItem: UIBarButtonItem!
    
    var setting_vc: SettingViewController!
    
    @IBAction func saveBarButtonAction(_ sender: Any) {
        if nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            
            let updateURL = "http://simonhost.hopto.org/chatroom/updateUserName.php"
            let text = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) as! String
            Global.postToURL(url: updateURL, body: "tid=\(Global.selfData.id as! String)&name=\(text)") { (string, data) in
                if string == "0" {
                    DispatchQueue.main.async {
                        Global.selfData.username = text
                        self.setting_vc.viewDidLoad()
                        self.setting_vc.tableView.reloadData()
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "更改名稱"
        
        self.navigationItem.rightBarButtonItem = saveBarButtonItem
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
