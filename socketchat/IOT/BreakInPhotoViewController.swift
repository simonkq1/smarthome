//
//  BreakInPhotoViewController.swift
//  socketchat
//
//  Created by Simon on 2018/7/18.
//  Copyright © 2018年 Simon Chang. All rights reserved.
//

import UIKit
import WebKit

class BreakInPhotoViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    @IBOutlet weak var activityIcon: UIActivityIndicatorView!
    
    @IBOutlet weak var webView: WKWebView!
    var startUrl = GlobalParameter.piIPAddr + "/streaming/streamingFile"
    var pageTitle: String?
    var requestUrl: String?
    
    override func loadView() {
        super.loadView()
        webView.uiDelegate = self
        webView.navigationDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.allowsBackForwardNavigationGestures = true
        activityIcon.startAnimating()
        
        if let url = URL(string: startUrl) {
            let request = URLRequest(url: url)
            webView.load(request)
            
        }
    }
    
    // open "target_blank" link
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }
    
    // for basic auth
    func webView(_ webView: WKWebView, didReceive didReceiveAuthenticationChallenge: URLAuthenticationChallenge, completionHandler: @escaping(URLSession.AuthChallengeDisposition, URLCredential?) -> Void){
        let alertController = UIAlertController(title: "請登入Pi系統帳號", message: "", preferredStyle: .alert)
        weak var usernameTextField: UITextField!
        alertController.addTextField { textField in
            textField.placeholder = "帳號"
            usernameTextField = textField
        }
        weak var passwordTextField: UITextField!
        alertController.addTextField { textField in
            textField.placeholder = "密碼"
            textField.isSecureTextEntry = true
            passwordTextField = textField
        }
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { action in
            completionHandler(.cancelAuthenticationChallenge, nil)
        }))
        alertController.addAction(UIAlertAction(title: "登入", style: .default, handler: { action in
            let credential = URLCredential(user: usernameTextField.text!, password: passwordTextField.text!, persistence: URLCredential.Persistence.forSession)
            completionHandler(.useCredential, credential)
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.activityIcon.stopAnimating()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(_ animated: Bool) {
        webView.reload()
    }
    
}
