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
