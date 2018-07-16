//
//  MessagePopoverViewController.swift
//  socketchat
//
//  Created by admin on 2018/7/9.
//  Copyright © 2018年 Simon Chang. All rights reserved.
//

import UIKit

class MessagePopoverViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    var message_vc: MessageAndChatViewController!
    var selectList = ["刪除"]
    var height: CGFloat = 44
    var views: [UIView] = []
    var messageData:[String:String] = [:]
    

    
    @IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
        
        let tapview = sender.view
        let textLabel = tapview?.viewWithTag(10) as! UILabel
        
        switch textLabel.text {
        case "刪除":
            let deleteURL = "http://simonhost.hopto.org/chatroom/deleteGroupMessage.php"
            let gid = messageData["gid"] as! String
            Global.postToURL(url: deleteURL, body: "gid=\(gid)") { (string, data) in
                if string == "0" {
                    self.message_vc.message_board_vc.messageData = []
                    DispatchQueue.main.async {
                    let _ = self.message_vc.message_board_vc.loadMessageList()
                        self.message_vc.message_board_vc.tableView.reloadData()
                    }
                }else if string == "1"{
                    self.message_vc.message_board_vc.messageData = []
                }
            }
            self.dismiss(animated: true, completion: nil)
            message_vc.navigationController?.popViewController(animated: true)
        
        case "編輯":
            let vc = storyboard?.instantiateViewController(withIdentifier: "message_create_vc") as! AddMessageViewController
            vc.status = "編輯"
            vc.messageData = self.messageData
            vc.messageBoard_vc = self.message_vc.message_board_vc
            vc.message_and_chat_vc = self.message_vc
            self.dismiss(animated: true, completion: nil)
            self.message_vc.present(vc, animated: true, completion: nil)
            
            
            
        default:
            break
        }
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        self.view.backgroundColor = UIColor.white
        let num = NumberFormatter()
        let myper = num.number(from: Global.selfData.permission) as! Int
        let tarper = num.number(from: self.messageData["mod"] ?? "0") as! Int
        let myid = num.number(from: Global.selfData.id) as! Int
        let tarid = num.number(from: self.messageData["sid"] ?? "0") as! Int
        print("AAA")
        print(myid)
        print(tarid)
        if myid == tarid {
            self.selectList = ["編輯" ,"刪除"]
        }else if myper < tarper{
            self.selectList = ["刪除"]
        }
        views = addPopListLabel(list: selectList, size: CGSize(width: (message_vc.view.frame.size.width) / 3, height: height), startPoint: CGPoint(x: 0, y: 0))
        for i in views {
            self.view.addSubview(i)
        }
        
    }
    
    override func viewDidLayoutSubviews() {
            preferredContentSize = CGSize(width: (message_vc.view.frame.size.width) / 3, height: height * CGFloat(selectList.count) + 20)
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
