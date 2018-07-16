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
    
    
    func firstIndex() {
        let paraph = NSMutableParagraphStyle()
        paraph.firstLineHeadIndent = 2
        //样式属性集合
        
        let s1 = NSMutableAttributedString(string: self.text!, attributes: [NSAttributedStringKey.paragraphStyle:paraph])
        self.attributedText = s1
        
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
        self.clipsToBounds = false
        
        let shapelayer = CAShapeLayer()
        let linePath = UIBezierPath()
        for i in sides {
            switch i {
            case.up:
                linePath.move(to: CGPoint(x: 0, y: 0))
                linePath.addLine(to: CGPoint(x: self.bounds.size.width + 100, y: 0))
                break
            case .down:
                linePath.move(to: CGPoint(x: 0, y: self.bounds.size.height))
                linePath.addLine(to: CGPoint(x: self.bounds.size.width + 100, y: self.bounds.size.height))
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
        static var permission: String! = Global.memberData["mod"]
        static var account: String! = Global.memberData["account"]
        static var username: String! = Global.memberData["username"]
        static var id: String! = Global.memberData["id"]
        static var token: String? = ""
    }
    static var memberData: [String: String] = [:]
    
    static func reloadSelfData() {
        Global.selfData.permission = Global.memberData["mod"]
        Global.selfData.account = Global.memberData["account"]
        Global.selfData.username = Global.memberData["username"]
        Global.selfData.id = Global.memberData["id"]
    }
    static func postToURL(url: String, body: String, action: ((_ returnData: String?, _ returndata: Data?) -> Void)? = nil) {
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
                    action!(html, data)
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
    
    static func timeToNow(targetTime: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 8)
        let now = Date() + (60 * 60 * 8)
        
        let newTarget = dateFormatter.date(from: targetTime)
        let components = Calendar.current.dateComponents([.second], from: newTarget!, to: now).second
        
        if components! < 60 {
            return "剛剛"
        }else if components! >= 60, components! < 3600{
            let timecom = Calendar.current.dateComponents([.minute], from: newTarget!, to: now).minute as! Int
            return (timecom != 1) ? "\(timecom) 分鐘前" : "\(timecom) 分鐘前"
        }else if components! >= 3600, components! < 86400{
            let timecom = Calendar.current.dateComponents([.hour], from: newTarget!, to: now).hour as! Int
            return (timecom != 1) ? "\(timecom) 小時前" : "\(timecom) 小時前"
        }else if components! >= 86400{
            let timecom = Calendar.current.dateComponents([.day], from: newTarget!, to: now).day as! Int
            return (timecom != 1) ? "\(timecom) 天前" : "\(timecom) 天前"
        }else {
            return "error"
        }
    }
    
    class SocketServer: Global {
        
       static private var isStream: InputStream? = nil
       static private var outStream: OutputStream? = nil
        static var isConnect: Bool = false
        static var outConnect: Bool = false
        static var isReceive: Bool = false
        
        static func connectSocketServer() {
            let _ = Stream.getStreamsToHost(withName: "simonhost.hopto.org", port: 5000, inputStream: &Global.SocketServer.isStream, outputStream: &Global.SocketServer.outStream)
            if Global.SocketServer.isConnect == false {
                Global.SocketServer.isStream?.open()
                Global.SocketServer.isConnect = true
            }
            if Global.SocketServer.outConnect == false {
                Global.SocketServer.outStream?.open()
                Global.SocketServer.outConnect = true
            }
            let gid = "0"
            let noData = "naflqknflqwnfiqwnfoivnqwilncfqoiwncionqwiondi120ue1902ue09qwndi12y4891y284!@#!@#!@ED,qwiojndjioqwndioclqn21#!@"
            DispatchQueue.global().async {
                while true{
                    sleep(15)
                    if Global.SocketServer.isConnect {
                        let now = Date() + (60 * 60 * 8)
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
                        dateFormatter.timeZone = TimeZone(secondsFromGMT: 8)
                        let nowDate = dateFormatter.string(from: now)
                        
                        let textData = """
                        {"account":\"\(Global.selfData.account as! String)\","sid":\"\(Global.selfData.id as! String)\","username":\"\(Global.selfData.username as! String)\","text":\"\(noData)\","gid":\"\(gid)\","date":\"\(nowDate)\"}
                        """
                        Global.SocketServer.send(textData)
                    }
                }
            }
            
        }
        static func disconnectSocketServer() {
            Global.SocketServer.isStream?.close()
            Global.SocketServer.isConnect = false
            Global.SocketServer.outStream?.close()
            Global.SocketServer.outConnect = false
            Global.SocketServer.isReceive = false
        }
        
        static func receiveData(avaliable: @escaping (_ data: [String:Any]?) -> Void) {
            if Global.SocketServer.isConnect == false {
                Global.SocketServer.isStream?.open()
                Global.SocketServer.isConnect = true
            }
            if Global.SocketServer.outConnect == false {
                Global.SocketServer.outStream?.open()
                Global.SocketServer.outConnect = true
            }
            var buf = Array(repeating: UInt8(0), count: 1024)
            var jsonObject: [String : Any] = [:]
            DispatchQueue.global().async {
                while true {
                    if Global.SocketServer.isReceive == true {
                        if let n = Global.SocketServer.isStream?.read(&buf, maxLength: 1024) {
                            
                            let data = Data(bytes: buf, count: n)
                            do{
                                jsonObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String : Any]
                            }catch{
                                print(error)
                            }
                            
                            avaliable(jsonObject)
                        }
                    }
                    sleep(1/10)
                }
            }
        }
        
        static func send(_ string: String) {
            var buf = Array(repeating: UInt8(0), count: 1024)
            var data = string.data(using: .utf8)!
            
            data.copyBytes(to: &buf, count: data.count)
            Global.SocketServer.outStream?.write(buf, maxLength: data.count)
            
        }
    }
    
    
    
}



