//
//  PermissionPickerViewController.swift
//  socketchat
//
//  Created by admin on 2018/7/4.
//  Copyright © 2018年 Simon Chang. All rights reserved.
//

import UIKit

class PermissionPickerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    @IBOutlet weak var pickerView: UIPickerView!
    var permissionList = ["1", "2", "3", "4", "5", "6"]
    var targetper: Int!
    var myper: Int!
    
    @IBAction func CancelAction(_ sender: Any) {
        let permissionView = self.parent as? PermissionSettingViewController
        permissionView?.pickerConstraints.constant = -195
        UIView.animate(withDuration: 0.5) {
            permissionView?.view.layoutIfNeeded()
        }
        permissionView?.backgroundConstraints.constant = -667
        
    }
    @IBAction func okAction(_ sender: Any) {
        let permissionView = self.parent as? PermissionSettingViewController
        permissionView?.permissionLabel.text = permissionList[pickerView.selectedRow(inComponent: 0)]
        
        permissionView?.pickerConstraints.constant = -195
        UIView.animate(withDuration: 0.5) {
            permissionView?.view.layoutIfNeeded()
        }
        permissionView?.backgroundConstraints.constant = -667
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let removeNum = permissionList.index(of: Global.memberData["mod"]!)
        permissionList.removeFirst(removeNum!)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let permissionView = self.parent as? PermissionSettingViewController
        
        let pos = permissionList.index(of: (permissionView?.permission)!)
        if myper < targetper {
            pickerView.selectRow(pos!, inComponent: 0, animated: false)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return permissionList.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return permissionList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
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
