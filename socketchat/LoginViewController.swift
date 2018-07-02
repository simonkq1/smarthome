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
    let a = ViewController.memberData
    
    
    @IBAction func btn(_ sender: Any) {
        TouchID.verify(action: nil)
        
    }
    @IBAction func login(_ sender: Any) {
        let acc = accountText.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let pwd = passwordText.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if accountText.text == "" {
            
            
        }else if passwordText.text == "" {
            
            
        }
        
        if accountText.text != "", passwordText.text != "" {
            
            TouchID.verify {
                
                let signUpURL = URL(string: self.url)
                var request = URLRequest(url: signUpURL!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30)
                request.httpBody = "account=\(acc!)&password=\(pwd!)" .data(using: .utf8)
                request.httpMethod = "POST"
                let config = URLSessionConfiguration.default
                let session = URLSession(configuration: config)
                var status: String = ""
                let dataTesk = session.dataTask(with: request) { (data, response, error) in
                    
                    if let data = data {
                        let html = String(data:data, encoding: .utf8)
                        let jsonData = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:String]
                        //                    print(jsonData)
                        if jsonData["status"] != nil {
                            status = jsonData["status"] as! String
                        }
                        print(status)
                        if status == "0" {
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "chatroom_vc") as! ViewController
                            ViewController.memberData = jsonData
                            DispatchQueue.main.async {
                                self.show(vc, sender: nil)
                                //                            self.showAlert(title: "success", msg: "return to login page", action: nil)
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
        
        self.isEditing = false
        
        let fingerPrint = UserDefaults.standard.value(forKey: "fingerPrint")
        if ((fingerPrint != nil) && fingerPrint as! Bool) {
            let authenticationContext = LAContext()
            var error: NSError?
            
            
            let isTouchAvaliable = authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
            if isTouchAvaliable {
                print("OK")
                authenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "需要驗證指紋來確認您的身份信息") { (success, error) in
                    if success {
                        NSLog("通過驗證")
                        return
                    }else {
                        NSLog("驗證失敗")
                    }
                }
                
            }
        }
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
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
