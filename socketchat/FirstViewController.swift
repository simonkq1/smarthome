//
//  FirstViewController.swift
//  socketchat
//
//  Created by admin on 2018/7/12.
//  Copyright © 2018年 Simon Chang. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    @IBOutlet weak var safityBox: CircleButton!
    @IBOutlet weak var member: CircleButton!
    @IBOutlet weak var messageBoard: CircleButton!
    @IBOutlet weak var monitor: CircleButton!
    
    @IBOutlet weak var security: CircleButton!
    
    @IBOutlet weak var loadingActivity: UIActivityIndicatorView!
    var loading_vc: LoadingViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loading_vc = storyboard?.instantiateViewController(withIdentifier: "loading_vc") as! LoadingViewController
        loadingActivity.stopAnimating()
        // Do any additional setup after loading the view.
        safityBox.addTarget(self, action: #selector(safityBoxAction(sender:)), for: .touchUpInside)
        member.addTarget(self, action: #selector(memberAction(sender:)), for: .touchUpInside)
        messageBoard.addTarget(self, action: #selector(messageBoardAction(sender:)), for: .touchUpInside)
        monitor.addTarget(self, action: #selector(monitorAction(sender:)), for: .touchUpInside)
        security.addTarget(self, action: #selector(securityAction(sender:)), for: .touchUpInside)
    }
    
    
    
    override func viewDidDisappear(_ animated: Bool) {
        loading_vc.dismiss(animated: false, completion: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.present(loading_vc, animated: false, completion: nil)
        
        
        let backItem = UIBarButtonItem()
        backItem.title = "首頁"
        navigationItem.backBarButtonItem = backItem
        
    }
    
    
    @objc func safityBoxAction (sender: CircleButton) {
        
    }
    @objc func memberAction (sender: CircleButton) {
        
    }
    @objc func messageBoardAction (sender: CircleButton) {
        
    }
    @objc func monitorAction (sender: CircleButton) {
        let story = UIStoryboard(name: "IOT", bundle: Bundle(identifier: "Simon-Chang.-socketchat"))
        let vc = story.instantiateViewController(withIdentifier: "IOT_tabbar_ctrl") as! TabBarViewController
        show(vc, sender: self)
        vc.selectedIndex = 1
        
    }

    @objc func securityAction (sender: CircleButton) {
        let story = UIStoryboard(name: "IOT", bundle: Bundle(identifier: "Simon-Chang.-socketchat"))
        let vc = story.instantiateViewController(withIdentifier: "IOT_tabbar_ctrl") as! TabBarViewController
        show(vc, sender: self)
        vc.selectedIndex = 2
        
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
