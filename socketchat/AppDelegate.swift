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
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    var bgTask: UIBackgroundTaskIdentifier!
    
    let user = UserDefaults()
    let url = "http://simonhost.hopto.org/chatroom/logincheck.php"
    var myToken: String = ""
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        print("APP Delegate")
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.alert,.badge,.sound]) { (granted, error) in
                if granted {
                    DispatchQueue.main.async {
                        center.setNotificationCategories(self.setCategories())
                        application.registerForRemoteNotifications()
                        
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
                let status = autoLogin(tourl: url, account: acc, password: pwd, token: myToken)
                while Global.memberData.count <= 0 {
                    usleep(100000)
                }
                Global.SocketServer.connectSocketServer()
                self.window = UIWindow(frame: UIScreen.main.bounds)
                let story = UIStoryboard(name: "Main", bundle: Bundle(identifier: "Simon-Chang.-socketchat"))
                let vc = story.instantiateViewController(withIdentifier: "home_nc") as! UINavigationController
                self.window?.rootViewController = vc
                self.window?.makeKeyAndVisible()
            }else {
                let story = UIStoryboard(name: "Main", bundle: Bundle(identifier: "Simon-Chang.-socketchat"))
                let vc = story.instantiateViewController(withIdentifier: "login_vc") as! LoginViewController
                self.window?.rootViewController = vc
                self.window?.makeKeyAndVisible()
            }
        }else {
            let story = UIStoryboard(name: "Main", bundle: Bundle(identifier: "Simon-Chang.-socketchat"))
            let vc = story.instantiateViewController(withIdentifier: "login_vc") as! LoginViewController
            self.window?.rootViewController = vc
            self.window?.makeKeyAndVisible()
            
        }
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map {String(format: "%02.2hhx", $0)}.joined()
        
        if let defPwd = user.object(forKey: "password"), let defAcc = user.object(forKey: "account"), let defIsLogin = user.object(forKey: "isLogin") {
            
            let tokenurl = "http://simonhost.hopto.org/chatroom/updateToken.php"
            Global.postToURL(url: tokenurl, body: "tid=\(Global.selfData.id as! String)&token=\(token)") { (html, data) in
//                print("TOKEN : \(html)")
            }
        }
        
        myToken = token
        Global.selfData.token = token
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
    }
    
    func setCategories() -> Set<UNNotificationCategory>{
        
        var set = Set<UNNotificationCategory>()
        let a1 = UNNotificationAction(
            identifier: "a1", title: "照片", options: [.foreground]
        )
        
        let b1 = UNNotificationAction(
            identifier: "b1", title: "留言板", options: [.foreground]
        )
        
        let c1 = UNNotificationCategory(
            
            identifier: "c1", actions: [a1,b1], intentIdentifiers: [], options: []
        )
        
        set.insert(c1)
        return set
        
        
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        //print("1111111")
        let action = response.actionIdentifier
        _ = response.notification.request
        if action == "a1"{
            print("asadfsdfasdfsaf")
            let story = UIStoryboard(name: "IOT", bundle: Bundle(identifier: "Simon-Chang.-socketchat"))
            let vc = story.instantiateViewController(withIdentifier: "IOT_tabbar_ctrl") as! TabBarViewController
            self.window?.rootViewController?.show(vc, sender: nil)
            vc.selectedIndex = 2
        }
        
        if action == "b1"{
            print("asadfsdfasdfsaf")
            let story = UIStoryboard(name: "Main", bundle: Bundle(identifier: "Simon-Chang.-socketchat"))
            let vc = story.instantiateViewController(withIdentifier: "message_board_vc") as! MessageBoardViewController
            self.window?.rootViewController?.show(vc, sender: nil)
        }
        completionHandler()
    }
    
    func autoLogin(tourl: String, account: String, password: String, token: String) -> String {
        
        let acc = account.trimmingCharacters(in: .whitespacesAndNewlines)
        let pwd = password.trimmingCharacters(in: .whitespacesAndNewlines)
        var status: String = ""
        
        if account != "", password != "" {
            
            let signUpURL = URL(string: tourl)
            var request = URLRequest(url: signUpURL!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30)
            
            var formatter = DateFormatter()
            formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
            let now = formatter.string(from: Date())
            
            request.httpBody = "account=\(acc)&password=\(pwd)&token=\(token)&now=\(now)" .data(using: .utf8)
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
                        let story = UIStoryboard(name: "Main", bundle: Bundle(identifier: "Simon-Chang.-socketchat"))
                        let vc = story.instantiateViewController(withIdentifier: "login_vc") as! LoginViewController
                        self.window?.rootViewController = vc
                        self.window?.makeKeyAndVisible()
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
        //stopApp
        
        print("applicationWillResignActive")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        let offlineURL = "http://simonhost.hopto.org/chatroom/setOffline.php"
        
        bgTask = application.beginBackgroundTask(expirationHandler: {
            var time = 0
            if let defIsLogin = self.user.object(forKey: "isLogin"), defIsLogin as! Bool == true {
                DispatchQueue.global().async {
                    while time <= 150 {
                        time += 1
                        if time >= 150 {
                            Global.postToURL(url: offlineURL, body: "tid=\(Global.selfData.id as! String)&status=off")
                        }
                        sleep(1)
                    }
                }
            }
            Global.SocketServer.disconnectSocketServer()
            application.endBackgroundTask(self.bgTask)
            self.bgTask = UIBackgroundTaskInvalid
        })
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        print("applicationWillEnterForeground")
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        //startAPP
        
        if let defIsLogin = user.object(forKey: "isLogin"), defIsLogin as! Bool == true {
            
            let offlineURL = "http://simonhost.hopto.org/chatroom/setOffline.php"
            Global.postToURL(url: offlineURL, body: "tid=\(Global.selfData.id as! String)&status=on")
            if Global.SocketServer.isConnect == false {
                Global.SocketServer.connectSocketServer()
                self.window?.reloadInputViews()
                
            }
        }
        print("applicationDidBecomeActive")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        print("applicationWillTerminate")
    }
    
    
}

