//
//  UnlockViewController.swift
//  socketchat
//
//  Created by Simon on 2018/7/18.
//  Copyright © 2018年 Simon Chang. All rights reserved.
//

import UIKit
import CoreBluetooth
import CoreLocation
class UnlockViewController: UIViewController,CLLocationManagerDelegate {
    
    
    
    let url = URL(string: "http://10.3.141.111/cgi-bin/openLockerCgi.cgi")
    
    
    var circleViewVC: CircleViewController!
    
    let lm = CLLocationManager()
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(clearBtnStatusToDisable), name: Notification.Name.UIApplicationDidBecomeActive, object: nil)
        
        
        for vc in (self.childViewControllers) {
            if vc.restorationIdentifier == "CircleView" {
                circleViewVC = vc as! CircleViewController
                break
            }
        }
        
        
        lm.requestAlwaysAuthorization()
        lm.requestWhenInUseAuthorization()
        lm.delegate = self
        //openLockBtn.isEnabled = false
        //openLockBtn.isHidden = true
        //circleViewVC.openLockBtn.isEnabled = true
        let uuid = UUID(uuidString: "E20A39F4-73F5-4BC4-A12F-17D1AD07A961") //Brand ID
        let region = CLBeaconRegion(proximityUUID: uuid!, identifier: "myregion")
        
        // 用來得知附近 beacon 的資訊。觸發1號method
        lm.startRangingBeacons(in: region)
        // 用來接收進入區域或離開區域的通知。觸發2號與3號method
        lm.startMonitoring(for: region)
        // Do any additional setup after loading the view, typically from a nib.
        //let image = UIImage(named: "lock.png")
        //openLockBtn.setImage(image, for: .normal)
        //openLockBtn.imageEdgeInsets = UIEdgeInsetsMake(150,150, 150,150);
        
    }
    
    @objc func clearBtnStatusToDisable(){
        blueToothDetect = [false,false,false]
        circleViewVC.openLockBtn.isEnabled = false
    }
    
    
    
    
    var blueToothDetect: Set = [false,false,false]
    var blueToothDetectCounter = 0
    /* 1號method */
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        for beacon in beacons {
            print("major=\(beacon.major) minor=\(beacon.minor) accury=\(beacon.accuracy) rssi=\(beacon.rssi)")
            
            switch beacon.proximity {
            case .far:
                print("beacon距離遠")
                //openLockBtn.isEnabled = false
                
            case .near:
                print("beacon距離近")
                //openLockBtn.isEnabled = false
                
            case .immediate:
                print("beacon就在旁邊")
                //openLockBtn.isEnabled = true
                
                blueToothDetect.insert(true)
                
            case .unknown:
                print("beacon距離未知")
                //openLockBtn.isEnabled = false
            }
            
            
            
            
            
            
            if blueToothDetect.contains(true){
                //
                //openLockBtn.isEnabled = true
                
                print("111111")
                if !circleViewVC.layerChangingStatus{
                    circleViewVC.openLockBtn.isEnabled = true
                    circleViewVC.addWhiteLayer()
                    circleViewVC.addGreenInnerLayer()
                }
                
                
            }else{
                //openLockBtn.isEnabled = false
                
                
                
                if !circleViewVC.layerChangingStatus{
                    circleViewVC.openLockBtn.isEnabled = false
                    circleViewVC.addGreyLayer()
                }
            }
            
        }
        
        blueToothDetectCounter += 1
        if blueToothDetectCounter % 3 == 0{
            blueToothDetect = []
        }
        
    }
    
    /* 2號method */
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        // 進入區域
        print("Enter \(region.identifier)")
    }
    
    /* 3號method */
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        // 離開區域
        print("Exit \(region.identifier)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("AAAABBBBB")
        clearBtnStatusToDisable()
    }
    
    
}
