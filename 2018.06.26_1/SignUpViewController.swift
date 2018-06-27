//
//  SignUpViewController.swift
//  2018.06.26_1
//
//  Created by admin on 2018/6/27.
//  Copyright © 2018年 Simon Chang. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    let url = "http://192.168.211.146/chatroom/signUp.php"

    @IBOutlet weak var accountText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    @IBOutlet weak var realnameText: UITextField!
    @IBAction func signup(_ sender: Any) {
        let acc = accountText.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let pwd = passwordText.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let rel = realnameText.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if accountText.text == "" {
            
        }else if passwordText.text == "" {
            
        }else if realnameText.text == "" {
            
        }
        
        if accountText.text != "", passwordText.text != "", realnameText.text != "" {
            let signUpURL = URL(string: url)
            var request = URLRequest(url: signUpURL!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30)
            request.httpBody = "account=\(acc!)&password=\(pwd!)&realName=\(rel!)" .data(using: .utf8)
            request.httpMethod = "POST"
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            let dataTesk = session.dataTask(with: request) { (data, response, error) in
                
                if let data = data {
                    let html = String(data:data, encoding: .utf8)
                    if html == "0" {
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
//                            self.performSegue(withIdentifier: "vc_to_welcome", sender: self)
                        }
                    }else{
                        let alert = UIAlertController(title: "Error", message: "Account or password is wrong", preferredStyle: .alert)
                        let OK = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alert.addAction(OK)
                        self.present(alert,animated: true,completion: nil)
                        //                        DispatchQueue.main.async {
                        //                            self.errorMessage.alpha = 1
                        //                            self.errorMessage.textColor = .red
                        //                        }
                    }
                }
            }
            
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
