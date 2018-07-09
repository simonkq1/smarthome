//
//  Global.swift
//  socketchat
//
//  Created by admin on 2018/7/3.
//  Copyright © 2018年 Simon Chang. All rights reserved.
//

import UIKit


extension UILabel {
    func drawUpperLine() {
        let shapeLayer = CAShapeLayer()
        let linePath = UIBezierPath()
        
        linePath.move(to: CGPoint(x: 0, y: 0))
        linePath.addLine(to: CGPoint(x: self.frame.size.width + 10, y: 0))
        
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 0.5
        
        shapeLayer.path = linePath.cgPath
        
        self.layer.addSublayer(shapeLayer)
        
    }
}
extension UIView {
    
    enum BorderSides {
        case up
        case down
        case left
        case right
    }
    
    func drawborder(width: CGFloat, color: UIColor,sides: [BorderSides]) {
//        self.clipsToBounds = true
        
        let shapelayer = CAShapeLayer()
        let linePath = UIBezierPath()
        for i in sides {
            switch i {
            case.up:
                linePath.move(to: CGPoint(x: 0, y: 0))
                linePath.addLine(to: CGPoint(x: self.bounds.size.width + 10, y: 0))
                break
            case .down:
                linePath.move(to: CGPoint(x: 0, y: self.bounds.size.height))
                linePath.addLine(to: CGPoint(x: self.bounds.size.width + 10, y: self.bounds.size.height))
                break
            case .left:
                linePath.move(to: CGPoint(x: 0, y: 0))
                linePath.addLine(to: CGPoint(x: 0, y: self.bounds.size.height))
                break
            case .right:
                linePath.move(to: CGPoint(x: self.bounds.size.width, y: 0))
                linePath.addLine(to: CGPoint(x: self.bounds.size.width, y: self.bounds.size.height))
                break
            }
            shapelayer.strokeColor = color.cgColor
            shapelayer.fillColor = UIColor.clear.cgColor
            shapelayer.lineWidth = width
            shapelayer.path = linePath.cgPath
            
            self.layer.addSublayer(shapelayer)
        }
        
        
        
    }
}

class Global: NSObject {
    class selfData: Global {
        
        static var permission: String = Global.memberData["mod"]!
        static var account: String = Global.memberData["account"]!
        static var username: String = Global.memberData["rname"]!
        static var id: String = Global.memberData["id"]!
        static var token: String = ""
    }
    static var memberData: [String: String] = [:]
    static func postToURL(url: String, body: String, action: ((_ returnData: String?) -> Void)? = nil) {
        let postURL = URL(string: url)
        var request = URLRequest(url: postURL!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30)
        request.httpBody = body .data(using: .utf8)
        request.httpMethod = "POST"
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                let html = String(data: data, encoding: .utf8)
                if action != nil {
                    action!(html)
                }
                
                print(html)
            }
        }
        dataTask.resume()
    }
    
    static func editingNextTextField(first: UITextField, next: UITextField) {
        first.endEditing(true)
        next.becomeFirstResponder()
    }
    
    
    
    static func autoLogin(tourl: String, account: String, password: String) -> String {
        let acc = account.trimmingCharacters(in: .whitespacesAndNewlines)
        let pwd = password.trimmingCharacters(in: .whitespacesAndNewlines)
        var status: String = ""
        DispatchQueue.main.async {
            
            if account != "", password != "" {
                
                //            TouchID.verify {
                let signUpURL = URL(string: tourl)
                var request = URLRequest(url: signUpURL!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30)
                request.httpBody = "account=\(acc)&password=\(pwd)" .data(using: .utf8)
                request.httpMethod = "POST"
                let config = URLSessionConfiguration.default
                let session = URLSession(configuration: config)
                sleep(2)
                let dataTesk = session.dataTask(with: request) { (data, response, error) in
                    
                    if let data = data {
                        let html = String(data:data, encoding: .utf8)
                        let jsonData = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:String]
                        if jsonData["status"] != nil {
                            status = jsonData["status"] as! String
                        }
                        print(status)
                        if status == "0" {
                            self.memberData = jsonData
                            
                        }else {
                            
                        }
                    }
                }
                dataTesk.resume()
            }
        }
        return status
    }
    
    
    
    func addPopListLabel(tablelist: [String], size: CGSize, startPoint: CGPoint, tapAction: Selector) -> [UIView] {
        var labelArray: [UILabel] = []
        var viewArr: [UIView] = []
        for i in 0..<tablelist.count {
            let textLayer = UILabel()
            let viewObject = UIView()
            viewObject.frame.size = size
            viewObject.frame.origin = CGPoint(x: 0, y: 10 + size.height * CGFloat(i))
            textLayer.text = tablelist[i]
            
            textLayer.frame.size = viewObject.frame.size
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
            if viewObject.tag < tablelist.count {
                viewObject.layer.addSublayer(drawButtonLine(width: size.width, height: size.height))
            }
            
            viewObject.addGestureRecognizer(UITapGestureRecognizer(target: self, action: tapAction))
        }
        return viewArr
    }
    
    private func drawButtonLine( width: CGFloat, height: CGFloat) -> CAShapeLayer {
        
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
    
    
    
}



