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
    var views: [UIView] = []
    let user = UserDefaults()
    
    
    @IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
        
        let tapview = sender.view
        let textLabel = tapview?.viewWithTag(10) as! UILabel
        switch textLabel.text {
        case "Add":
            //add
            print("A")
        case "Select":
            //select
            memberTable_vc.status = "Select"
            memberTable_vc.barEditBtn.image = nil
            memberTable_vc.barEditBtn.title = "Edit"
            memberTable_vc.navigationItem.rightBarButtonItem = memberTable_vc.barEditBtn
            memberTable_vc.editPermissionButton()
            memberTable_vc.isEdit = true
            
            memberTable_vc.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: memberTable_vc, action: #selector(memberTable_vc.cancelButton))
            memberTable_vc.tableView.reloadData()
           
            self.dismiss(animated: true, completion: nil)
            break
        case "Delete":
            //delete
            print("Delete")
            memberTable_vc.popoverSelectAction(status: "Delete", rightItemTitle: "Delete", cancelAction: #selector(memberTable_vc.cancelButton), editAction: #selector(memberTable_vc.deleteButton))
//            memberTable_vc.tableView.reloadData()
            self.dismiss(animated: true, completion: nil)
            break
        case "Reload":
            memberTable_vc.reloadButton()
            self.dismiss(animated: true, completion: nil)
            break
        case "Logout":
            if let _ = user.object(forKey: "password") {
                user.removeObject(forKey: "password")
            }
            if let _ = user.object(forKey: "account") {
                user.removeObject(forKey: "account")
            }
            if let _ = user.object(forKey: "isLogin") {
                user.removeObject(forKey: "isLogin")
            }
            let logoutURL = "http://simonhost.hopto.org/chatroom/logout.php"
            
            Global.postToURL(url: logoutURL, body: "id=\(Global.selfData.id)")
            
            let vc = storyboard?.instantiateViewController(withIdentifier: "login_vc") as! LoginViewController
            showDetailViewController(vc, sender: nil)
            break
        case "Permission":
            if memberTable_vc.permissionTarget != nil {
                let vc = storyboard?.instantiateViewController(withIdentifier: "permission_vc") as! PermissionSettingViewController
                vc.name = memberTable_vc.memberList[memberTable_vc.permissionTarget!]["account"]!
                vc.permission = memberTable_vc.memberList[memberTable_vc.permissionTarget!]["mod"]!
                vc.tid = memberTable_vc.memberList[memberTable_vc.permissionTarget!]["id"]!
                vc.memberView = memberTable_vc
                self.dismiss(animated: true, completion: nil)
                memberTable_vc.present(vc, animated: true, completion: nil)

            }
            break
        default:
            break
        }
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        member = Global.memberData
        
        myPermission = Int(member["mod"]!)
        memberTable_vc.myPermission = myPermission
        switch myPermission {
        case 1:
            settingList = ["Select", "Delete", "Reload", "Logout"]
            break
        case 2:
            settingList = ["Select", "Delete", "Reload", "Logout"]
            break
        case 3:
            settingList = ["Select", "Reload", "Logout"]
            break
        case 4:
            settingList = ["Select", "Reload", "Logout"]
            break
        case 5:
            settingList = ["Reload", "Logout"]
            break
        case 6:
            settingList = ["Reload", "Logout"]
            break
        default:
            settingList = ["Select", "Delete", "Reload", "Logout"]
        }
        switch memberTable_vc.status {
        case "Select":
            views = addPopListLabel(list: selectList, size: CGSize(width: (memberTable_vc.view.frame.size.width) / 3, height: height), startPoint: CGPoint(x: 0, y: 0))
            break
        default:
             views = addPopListLabel(list: settingList, size: CGSize(width: (memberTable_vc.view.frame.size.width) / 3, height: height), startPoint: CGPoint(x: 0, y: 0))
        }
        
        
        for i in views {
            self.view.addSubview(i)
        }
    }
    
    override func viewDidLayoutSubviews() {
        switch memberTable_vc.status {
        case "Select":
            self.preferredContentSize = CGSize(width: (memberTable_vc.view.frame.size.width) / 3, height: height * CGFloat(selectList.count) + 20)
        default:
            self.preferredContentSize = CGSize(width: (memberTable_vc.view.frame.size.width) / 3, height: height * CGFloat(settingList.count) + 20)
        }
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
                viewObject.layer.addSublayer(drawButtomLine(width: size.width, height: size.height))
            }
            
            viewObject.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapGesture(_:))))
        }
        return viewArr
    }
    
    func drawButtomLine( width: CGFloat, height: CGFloat) -> CAShapeLayer {
        
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
