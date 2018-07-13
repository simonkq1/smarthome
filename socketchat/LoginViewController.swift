//
//  LoginViewController.swift
//  2018.06.26_1
//
//  Created by admin on 2018/6/27.
//  Copyright © 2018年 Simon Chang. All rights reserved.
//

import UIKit
import LocalAuthentication

class LoginViewController: UIViewController {
    let url = "http://simonhost.hopto.org/chatroom/logincheck.php"
//    let url = "http://192.168.211.146/chatroom/logincheck.php"
    
    @IBOutlet weak var accountText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    let home = NSHomeDirectory()
    let user = UserDefaults()
    var isShowPassword: Bool = false
    
    
    @IBAction func login(_ sender: UIButton) {
        let acc = accountText.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let pwd = passwordText.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if accountText.text == "" {
            
            
        }else if passwordText.text == "" {
            
        }
        
        if accountText.text != "", passwordText.text != "" {
            
            sender.isEnabled = false
            if #available(iOS 10.0, *) {
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
                    sender.isEnabled = true
                }
            } else {
                // Fallback on earlier versions
            }
            login(tourl: url, account: accountText.text!, password: passwordText.text!)
            
        }
    }
    
    @IBAction func showPassword(_ sender: UIButton) {
        isShowPassword = !isShowPassword
        if isShowPassword {
            passwordText.isSecureTextEntry = false
            sender.setTitle("hide", for: .normal)
        }else {
            passwordText.isSecureTextEntry = true
            sender.setTitle("show", for: .normal)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        
        self.isEditing = false
        accountText.addTarget(self, action: #selector(accountEndEditing(sender:)), for: .editingDidEndOnExit)
        passwordText.addTarget(self, action: #selector(login(_:)), for: .editingDidEndOnExit)
        passwordText.isSecureTextEntry = true
        
    }
    
    
    func login(tourl: String, account: String, password: String) {
        
        let acc = account.trimmingCharacters(in: .whitespacesAndNewlines)
        let pwd = password.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if account == "" {
            
        }else if password == "" {
            
        }
        
        if account != "", password != "" {
            
            //            TouchID.verify {
            let signUpURL = URL(string: tourl)
            var request = URLRequest(url: signUpURL!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30)
            request.httpBody = "account=\(acc)&password=\(pwd)" .data(using: .utf8)
            request.httpMethod = "POST"
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            var status: String = ""
            let dataTesk = session.dataTask(with: request) { (data, response, error) in
                
                if let data = data {
                    let html = String(data:data, encoding: .utf8)
                    let jsonData = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:String]
                    if jsonData["status"] != nil {
                        status = jsonData["status"] as! String
                    }
                    print(status)
                    if status == "0" {
                        //                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "chatroom_vc") as! ViewController
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "home_nc") as! UINavigationController
                        
                        self.user.set(acc, forKey: "account")
                        self.user.set(pwd, forKey: "password")
                        self.user.set(true, forKey: "isLogin")
                        self.user.synchronize()
                        self.accountText.borderStyle = .roundedRect
                        //                            ViewController.memberData = jsonData
                        Global.memberData = jsonData
                        Global.reloadSelfData()
                        self.updateToken(id: Global.selfData.id!)
                        
                        Global.SocketServer.connectSocketServer()
                        DispatchQueue.main.async {
                            self.show(vc, sender: nil)
                        }
                    }else if status == "1" {
                        DispatchQueue.main.async {
                            self.showAlert(title: "Error", msg: "Password wrong", action: nil)
                        }
                        
                    }else if status == "2" {
                        DispatchQueue.main.async {
                            self.showAlert(title: "Error", msg: "Account is not exist", action: nil)
                        }
                    }else {
                        DispatchQueue.main.async {
                            self.showAlert(title: "Error", msg: "connect error", action: nil)
                            
                        }
                    }
                }
            }
            dataTesk.resume()
        }
    }
    func updateToken(id: String) {
        
        let tokenurl = "http://simonhost.hopto.org/chatroom/updateToken.php"
        print("ID : \(Global.selfData.id)")
        Global.postToURL(url: tokenurl, body: "tid=\(Global.selfData.id)&token=\(Global.selfData.token)") { (html, data) in
            print("TOKEN : \(html)")
        }
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func accountEndEditing(sender: UITextField) {
        Global.editingNextTextField(first: sender, next: passwordText)
    }
    
    func showAlert(title: String, msg: String , action: ((UIAlertAction) -> Void)?) {
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let OK = UIAlertAction(title: "OK", style: .cancel, handler: action)
        alert.addAction(OK)
        self.present(alert,animated: true,completion: nil)
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
