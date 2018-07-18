//
//  PermissionSettingViewController.swift
//  socketchat
//
//  Created by admin on 2018/7/4.
//  Copyright © 2018年 Simon Chang. All rights reserved.
//

import UIKit

class PermissionSettingViewController: UIViewController {
    
    
    @IBOutlet weak var permissionEditButton: UIButton!
    @IBOutlet weak var backgroundConstraints: NSLayoutConstraint!
    @IBOutlet weak var pickerConstraints: NSLayoutConstraint!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var permissionLabel: UILabel!
    var name: String = ""
    var permission: String = ""
    var tid: String = ""
    var permission_picker: PermissionPickerViewController!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    var memberView: MemberTableViewController!
    
    @IBAction func okAction(_ sender: Any) {
        
        
        var isCheck: Bool = false
        let url = "http://simonhost.hopto.org/chatroom/chmod.php"
        let mod = permission_picker.permissionList[permission_picker.pickerView.selectedRow(inComponent: 0)]
        
        if permission != mod {
            
            Global.postToURL(url: url, body: "tid=\(tid)&mod=\(mod)") { (html, data) in
                if html == "1" {
                    self.memberView.loadMemberList()
                }
            }
        }
        memberView.cancelButton()
        memberView.permissionTarget = nil
        memberView.barEditBtn.title = ""
        memberView.barEditBtn.image = UIImage(named: "setting")
        DispatchQueue.main.async {
            
            self.memberView.navigationItem.rightBarButtonItem = self.memberView.barEditBtn
            self.memberView.barEditBtn.isEnabled = true
        }
        memberView.reloadTable()
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        for i in 0..<memberView.radioIsSelected.count {
            memberView.radioIsSelected[i] = false
            memberView.isEdit = false
        }
        memberView.cancelButton()
        memberView.permissionTarget = nil
        memberView.barEditBtn.title = ""
        memberView.barEditBtn.image = UIImage(named: "setting")
        DispatchQueue.main.async {
            
            self.memberView.navigationItem.rightBarButtonItem = self.memberView.barEditBtn
            self.memberView.barEditBtn.isEnabled = true
        }
        memberView.reloadTable()
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
        
//        alertView.frame = CGRect(x: alertView.frame.origin, y: <#T##CGFloat#>, width: <#T##CGFloat#>, height: <#T##CGFloat#>)
        self.preferredContentSize = CGSize(width: self.view.frame.size.width, height: self.view.frame.height / 3)
        
        for i in view.constraints {
            if i.identifier == "button_bottom" {
                i.constant = 0
            }
        }
        
        nameLabel.text = name
        permissionLabel.text = permission
        
        // Do any additional setup after loading the view.
        for i in childViewControllers {
            if i.restorationIdentifier == "permission_picker" {
                permission_picker = i as! PermissionPickerViewController
            }
        }
        let myper = Int(Global.memberData["mod"]!)
        let targetper = Int(permission)
        permission_picker.targetper = targetper
        permission_picker.myper = myper
                if targetper! <= myper! {
                    self.permissionEditButton.isEnabled = false
                    self.permissionEditButton.alpha = 0
                }
        
        
        alertView.layer.cornerRadius = 10
    }
    override func viewDidAppear(_ animated: Bool) {
        
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
