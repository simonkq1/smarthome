//
//  PopoverViewController.swift
//  socketchat
//
//  Created by admin on 2018/7/5.
//  Copyright © 2018年 Simon Chang. All rights reserved.
//

import UIKit

class PopoverViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    var popsize: CGRect! = nil

    var settingList = ["Add", "Select", "Delete", "Reload"]
    let selectList = ["Permission"]
    var member: [String:String] = [:]
    var myPermission: Int!
    var height: CGFloat = 44
    var status: String = ""
    var isEdit: Bool = false
    var memberTable_vc: MemberTableViewController!
    
    
    @IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
        
        let tapview = sender.view
        let textLabel = tapview?.viewWithTag(10) as! UILabel
        switch textLabel.text {
        case "Add":
            //add
            print("A")
        case "Select":
            //select
            self.dismiss(animated: true, completion: nil)
//            popoverSelectAction(status: "Select", rightItemTitle: "Edit", cancelAction: #selector(cancelButton), editAction: #selector(editButton))
            break
        case "Delete":
            //delete
//            popoverSelectAction(status: "Delete", rightItemTitle: "Delete", cancelAction: #selector(cancelButton), editAction: #selector(deleteButton))
//
//            tableView.reloadData()
            break
        case "Reload":
//            reloadButton()
//            popover.dismiss()
            break
        case "Logout":
            let vc = storyboard?.instantiateViewController(withIdentifier: "login_vc") as! LoginViewController
            showDetailViewController(vc, sender: nil)
            break
        case "Permission":
//            if permissionTarget != nil {
//                let vc = storyboard?.instantiateViewController(withIdentifier: "permission_vc") as! PermissionSettingViewController
//                vc.name = memberList[permissionTarget!]["account"]!
//                vc.permission = memberList[permissionTarget!]["mod"]!
//                vc.tid = memberList[permissionTarget!]["id"]!
//                vc.memberView = self
//                present(vc, animated: true, completion: nil)
//
//            }
//            popover.dismiss()
            break
        default:
            break
        }
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        member = Global.memberData
        
        myPermission = 1
        switch myPermission {
        case 1:
            settingList = ["Add", "Select", "Delete", "Reload", "Logout"]
        case 2:
            settingList = ["Add", "Select", "Delete", "Reload", "Logout"]
        case 3:
            settingList = ["Add", "Select", "Reload", "Logout"]
        case 4:
            settingList = ["Add", "Select", "Reload", "Logout"]
        case 5:
            settingList = ["Add", "Reload", "Logout"]
        case 6:
            settingList = ["Reload", "Logout"]
        default:
            settingList = ["Add", "Select", "Delete", "Reload", "Logout"]
        }
        
        memberTable_vc = storyboard?.instantiateViewController(withIdentifier: "memberTable_vc") as! MemberTableViewController
        let views = addPopListLabel(list: settingList, size: CGSize(width: (memberTable_vc.view.frame.size.width) / 3, height: height), startPoint: CGPoint(x: 0, y: 0))
        
        for i in views {
            self.view.addSubview(i)
        }
    }
    
    override func viewDidLayoutSubviews() {
        self.preferredContentSize = CGSize(width: (memberTable_vc.view.frame.size.width) / 3, height: height * CGFloat(settingList.count) + 20)
    }
    
    
    func popoverSelectAction(status: String,rightItemTitle: String, cancelAction: Selector? = #selector(cancelButton), editAction: Selector? = nil) {
        
        self.status = status
        let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: cancelAction)
        let EditBarButton = UIBarButtonItem(title: rightItemTitle, style: .plain, target: self, action: editAction)
        navigationItem.leftBarButtonItem = cancelBarButton
        navigationItem.rightBarButtonItem = EditBarButton
        memberTable_vc.isEdit = true
        memberTable_vc.tableView.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func editButton() {
        showPopView(list: selectList)
    }
    
    @objc func reloadButton() {
        isEdit = false
        for i in 0..<radioIsSelected.count {
            radioIsSelected[i] = false
        }
        DispatchQueue.main.async {
            self.loadMemberList()
            self.tableView.reloadData()
        }
        navigationItem.leftBarButtonItem = nil
        navigationItem.rightBarButtonItem = editButtonItem
        editButtonItem.image = UIImage(named: "setting")
        editButtonItem.action = #selector(editBtn(_:))
        status = ""
        deleteTarget = []
    }
    
    
    @objc func deleteButton() {
        isEdit = false
        if deleteTarget.count != 0 {
            let deleteurl = "http://simonhost.hopto.org/chatroom/deleteMember.php"
            if deleteTarget.count != 0 {
                for i in deleteTarget {
                    let id = memberList[i]["id"] as! String
                    postToURL(url: deleteurl, body: "target=\(id)") { (data) in
                        self.loadMemberList()
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }else {
            tableView.reloadData()
        }
        deleteTarget = []
        
        navigationItem.rightBarButtonItem = editButtonItem
        navigationItem.leftBarButtonItem = nil
        editButtonItem.image = UIImage(named: "setting")
        editButtonItem.action = #selector(editBtn(_:))
        
        
    }
    @objc func cancelButton() {
        isEdit = false
        for i in 0..<memberTable_vc.radioIsSelected.count {
            memberTable_vc.radioIsSelected[i] = false
        }
        DispatchQueue.main.async {
            self.memberTable_vc.tableView.reloadData()
        }
        navigationItem.leftBarButtonItem = nil
        navigationItem.rightBarButtonItem = editButtonItem
        editButtonItem.image = UIImage(named: "setting")
        editButtonItem.action = #selector(editBtn(_:))
        status = ""
        memberTable_vc.deleteTarget = []
        
    }
    
    
    
    
    
    func addPopListLabel(list: [String], size: CGSize, startPoint: CGPoint) -> [UIView] {
        var labelArray: [UILabel] = []
        var viewArr: [UIView] = []
        for i in 0..<list.count {
            let textLayer = UILabel()
            let viewObject = UIView()
            viewObject.frame.size = size
            viewObject.frame.origin = CGPoint(x: 0, y: 10 + size.height * CGFloat(i))
            textLayer.text = list[i]
            
            textLayer.frame.size = size
            textLayer.bounds.origin = CGPoint(x: 0, y: 0)
            textLayer.textColor = UIColor.black
            textLayer.font = UIFont(name: "System", size: 15)
//            textLayer.layer.borderWidth = 1
            textLayer.textAlignment = .center
            textLayer.tag = 10
            
            viewArr.append(viewObject)
            labelArray.append(textLayer)
            viewObject.addSubview(textLayer)
            viewObject.tag = i + 1
            if viewObject.tag < list.count {
                viewObject.layer.addSublayer(drawButtonLine(width: size.width, height: size.height))
            }
            
            viewObject.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapGesture(_:))))
        }
        return viewArr
    }
    
    func drawButtonLine( width: CGFloat, height: CGFloat) -> CAShapeLayer {
        
        let shapeLayer = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: 0, y: height))
        linePath.addLine(to: CGPoint(x: width, y: height))
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 0.5
        shapeLayer.path = linePath.cgPath
        
        return shapeLayer
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
