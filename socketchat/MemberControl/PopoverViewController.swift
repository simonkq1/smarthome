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

    var settingList = ["Add", "選取", "刪除", "重新載入"]
    let selectList = ["權限"]
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
        case "選取":
            //選取
            memberTable_vc.status = "選取"
            memberTable_vc.barEditBtn.image = nil
            memberTable_vc.barEditBtn.title = "編輯"
            memberTable_vc.navigationItem.rightBarButtonItem = memberTable_vc.barEditBtn
            memberTable_vc.editPermissionButton()
            memberTable_vc.isEdit = true
            
            memberTable_vc.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: memberTable_vc, action: #selector(memberTable_vc.cancelButton))
            memberTable_vc.tableView.reloadData()
           
            self.dismiss(animated: true, completion: nil)
            break
        case "刪除":
            //刪除
            print("刪除")
            memberTable_vc.popoverSelectAction(status: "刪除", rightItemTitle: "刪除", cancelAction: #selector(memberTable_vc.cancelButton), editAction: #selector(memberTable_vc.deleteButton))
//            memberTable_vc.tableView.reloadData()
            self.dismiss(animated: true, completion: nil)
            break
        case "重新載入":
            memberTable_vc.reloadButton()
            self.dismiss(animated: true, completion: nil)
            break
        case "登出":
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
            
            Global.postToURL(url: logoutURL, body: "id=\(Global.selfData.id as! String)")
            
            let vc = storyboard?.instantiateViewController(withIdentifier: "login_vc") as! LoginViewController
            showDetailViewController(vc, sender: nil)
            Global.SocketServer.disconnectSocketServer()
            break
        case "權限":
            if memberTable_vc.permissionTarget != nil {
                let vc = storyboard?.instantiateViewController(withIdentifier: "permission_vc") as! PermissionSettingViewController
                vc.name = memberTable_vc.memberList[memberTable_vc.permissionTarget!]["account"]!
                vc.permission = memberTable_vc.memberList[memberTable_vc.permissionTarget!]["mod"]!
                vc.tid = memberTable_vc.memberList[memberTable_vc.permissionTarget!]["id"]!
                vc.memberView = self.memberTable_vc
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
            settingList = ["選取", "刪除", "重新載入", "登出"]
            break
        case 2:
            settingList = ["選取", "刪除", "重新載入", "登出"]
            break
        case 3:
            settingList = ["選取", "重新載入", "登出"]
            break
        case 4:
            settingList = ["選取", "重新載入", "登出"]
            break
        case 5:
            settingList = ["重新載入", "登出"]
            break
        case 6:
            settingList = ["重新載入", "登出"]
            break
        default:
            settingList = ["選取", "刪除", "重新載入", "登出"]
        }
        switch memberTable_vc.status {
        case "選取":
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
        case "選取":
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
