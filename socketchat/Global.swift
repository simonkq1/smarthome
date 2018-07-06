//
//  Global.swift
//  socketchat
//
//  Created by admin on 2018/7/3.
//  Copyright © 2018年 Simon Chang. All rights reserved.
//

import UIKit

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
}

//class KeyboardControl: UIViewController {
//    static private var usetarget: UIViewController!
//
//    func keyboardAutoRaiseUp() {
//        NotificationCenter.default.addObserver(target, selector: #selector(keyboardWillShow(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(target, selector: #selector(keyboardWillHide(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
//
//
//    }
//
//    @objc func keyboardWillShow(notification: NSNotification) {
//        guard let userInfo = notification.userInfo else {return}
//        guard let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue else {return}
//        let keyboardFrame = keyboardSize.cgRectValue
//        if self.view.frame.origin.y == 0 {
//            self.view.frame.origin.y -= keyboardFrame.height
//        }
//
//    }
//
//    @objc func keyboardWillHide(notification: NSNotification) {
//        if self.view.frame.origin.y != 0 {
//            self.view.frame.origin.y = 0
//        }
//    }
//}
