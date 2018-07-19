//
//  StreamingViewController.swift
//  socketchat
//
//  Created by admin on 2018/7/12.
//  Copyright © 2018年 Simon Chang. All rights reserved.
//

import UIKit
import WebKit
class StreamingViewController: UIViewController {
    
    
    @IBOutlet weak var activityIcon: UIActivityIndicatorView!
    
    @IBOutlet weak var streamingWebView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(streamingWebViewReload), name: Notification.Name.UIApplicationDidBecomeActive, object: nil)
        
        
    }
    
    @objc func streamingWebViewReload(){
        streamingWebView.reload()
        print("goBack")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        //print("viewdidAppear")
        
        
        
        let openStreamUrl = URL(string: (GlobalParameter.piIPAddr + "/cgi-bin/streaming.cgi"))
        let stopStreamUrl = URL(string: (GlobalParameter.piIPAddr + "/cgi-bin/stopStreaming.cgi"))
        
        
        
        DispatchQueue.global().async {
            
            
            do{
                DispatchQueue.main.sync {
                    self.activityIcon.startAnimating()
                }
                let _ = try String(contentsOf: stopStreamUrl!)
                sleep(1)
                print("abcde")
                let _ = try String(contentsOf: openStreamUrl!)
                
                
                
                
                
            }catch{
                
                print("Open Streaming Fail")
            }
            
            
        }
        
        //sleep(10)
        
        var timer:Timer!
        timer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(self.loadWebView), userInfo: nil, repeats: false)
        
        
        
        
    }
    
    
    @objc func loadWebView(){
        self.activityIcon.stopAnimating()
        let url = URL(string: (GlobalParameter.piIPAddr + "/streaming/stream.m3u8"))
        let request = URLRequest(url: url!)
        self.streamingWebView.load(request)
        
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        let stopStreamUrl = URL(string: (GlobalParameter.piIPAddr + "/cgi-bin/stopStreaming.cgi"))
        
        DispatchQueue.global().async {
            do{
                let _ = try String(contentsOf: stopStreamUrl!)
            }catch{
                
                print("Stop Streaming Fail")
            }
            
        }
        //print("viewdiddisAppear")
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
