//
//  AppDelegate.swift
//  2018.06.26_1
//
//  Created by admin on 2018/6/26.
//  Copyright © 2018年 Simon Chang. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let user = UserDefaults()
    let url = "http://simonhost.hopto.org/chatroom/logincheck.php"
    var myToken: String = ""


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        print("APP Delegate")
        
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert,.badge,.sound]) { (granted, error) in
                if granted {
                    DispatchQueue.main.async {
                        application.registerForRemoteNotifications()
//                        application.applicationIconBadgeNumber = 0
                    }
                }
            }
        } else {
            // Fallback on earlier versions
        }
            
        if let defPwd = user.object(forKey: "password"), let defAcc = user.object(forKey: "account"), let defIsLogin = user.object(forKey: "isLogin") {
            print("pwd : \(defPwd as! String) ==> acc : \(defAcc as! String)")
            let acc = defAcc as! String
            let pwd = defPwd as! String
            if defIsLogin as! Bool == true {
                print("Auto : \(myToken)")
                let status = autoLogin(tourl: url, account: acc, password: pwd, token: myToken)
                while Global.memberData.count <= 0 {
                    sleep(1/10)
                }
                    self.window = UIWindow(frame: UIScreen.main.bounds)
                    let story = UIStoryboard(name: "Main", bundle: Bundle(identifier: "Simon-Chang.-socketchat"))
//                    let vc = story.instantiateViewController(withIdentifier: "memberControl_vc") as! UINavigationController
                let vc = story.instantiateViewController(withIdentifier: "message_nc") as! UINavigationController
                    self.window?.rootViewController = vc
                    self.window?.makeKeyAndVisible()
            }else {
                self.window = UIWindow(frame: UIScreen.main.bounds)
                let story = UIStoryboard(name: "Main", bundle: Bundle(identifier: "Simon-Chang.-socketchat"))
                let vc = story.instantiateViewController(withIdentifier: "login_vc") as! UINavigationController
                self.window?.rootViewController = vc
                self.window?.makeKeyAndVisible()
            }
            
        }else {


        }
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map {String(format: "%02.2hhx", $0)}.joined()
        print(token)
        
        if let defPwd = user.object(forKey: "password"), let defAcc = user.object(forKey: "account"), let defIsLogin = user.object(forKey: "isLogin") {
            
            let tokenurl = "http://simonhost.hopto.org/chatroom/updateToken.php"
            print("ID : \(Global.selfData.id)")
            Global.postToURL(url: tokenurl, body: "tid=\(Global.selfData.id)&token=\(token)") { (data) in
                print("TOKEN : \(data)")
            }
        }
        
        myToken = token
        Global.selfData.token = token
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
    }
    
    
    func autoLogin(tourl: String, account: String, password: String, token: String) -> String {
        
        let acc = account.trimmingCharacters(in: .whitespacesAndNewlines)
        let pwd = password.trimmingCharacters(in: .whitespacesAndNewlines)
        var status: String = ""
        
        if account != "", password != "" {
            
            //            TouchID.verify {
            let signUpURL = URL(string: tourl)
            var request = URLRequest(url: signUpURL!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30)
            request.httpBody = "account=\(acc)&password=\(pwd)&token=\(token)" .data(using: .utf8)
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
                        Global.memberData = jsonData
                        
                    }else {
                        
                    }
                }
            }
            dataTesk.resume()
        }
        return status
}

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        print("applicationWillResignActive")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        print("applicationWillEnterForeground")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        print("applicationDidBecomeActive")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        print("applicationWillTerminate")
    }


}

