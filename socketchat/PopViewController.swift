//
//  PopViewController.swift
//  socketchat
//
//  Created by admin on 2018/7/5.
//  Copyright © 2018年 Simon Chang. All rights reserved.
//

import UIKit

class PopViewController: UIViewController, UIPopoverPresentationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let popctrl = segue.destination.popoverPresentationController
        
        if sender is UIButton {
            popctrl?.sourceRect = (sender as! UIButton).bounds
            popctrl?.permittedArrowDirections = .unknown
        }
        popctrl?.delegate = self
    }
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
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
