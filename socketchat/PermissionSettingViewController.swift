//
//  PermissionSettingViewController.swift
//  socketchat
//
//  Created by admin on 2018/7/4.
//  Copyright © 2018年 Simon Chang. All rights reserved.
//

import UIKit

class PermissionSettingViewController: UIViewController {
    

    @IBOutlet weak var backgroundConstraints: NSLayoutConstraint!
    @IBOutlet weak var pickerConstraints: NSLayoutConstraint!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var permissionLabel: UILabel!
    var name: String = ""
    var permission: String = ""
    var tid: String = ""
    
    @IBOutlet weak var cancelButton: UIButton!
    
    var memberView: MemberTableViewController!
    
    @IBAction func okAction(_ sender: Any) {
        
//        print(<#T##items: Any...##Any#>)
        let url = "http://simonhost.hopto.org/chatroom/chmod.php"
//        memberView.postToURL(url: url, body: "id=\(tid)&mod=\(permissionLabel.text)", action: nil)
//        print(memberView?.radioIsSelected)
    }
    @IBAction func cancelAction(_ sender: Any) {
        for i in 0..<memberView.radioIsSelected.count {
            memberView.radioIsSelected[i] = false
            memberView.isEdit = false
        }
        memberView.cancelButton()
        memberView.tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changePermission(_ sender: Any) {
        pickerConstraints.constant = 0
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        backgroundConstraints.constant = 0
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = name
        permissionLabel.text = permission

        // Do any additional setup after loading the view.
        
        alertView.layer.cornerRadius = 10
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
