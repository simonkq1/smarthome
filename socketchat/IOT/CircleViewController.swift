//
//  CircleViewController.swift
//  socketchat
//
//  Created by Simon on 2018/7/18.
//  Copyright © 2018年 Simon Chang. All rights reserved.
//

import UIKit

class CircleViewController: UIViewController {
    
    let url = URL(string: (GlobalParameter.piIPAddr + "/cgi-bin/openLockerCgi.cgi"))
    var timeRecorderOrder = 0;
    var layerChangingStatus:Bool = false
    var unlock_vc: UnlockViewController!
    @IBOutlet weak var openLockBtn: UIButton!
    @IBAction func onClickOpenLockBtn(_ sender: Any) {
        //        TouchID.verify {
        
        TouchID.verify {
            
            self.layerChangingStatus = true
            DispatchQueue.main.async {
                for layer in self.view.layer.sublayers!{
                    
                    if layer.name == "LayerWhite" || layer.name == "LayerGreen" || layer.name == "LayerGreenAni" || layer.name == "LayerGrey" {
                        layer.removeFromSuperlayer()
                    }
                    
                }
            }
            DispatchQueue.global().async {
                do{
                    
                    let _ = try String(contentsOf: self.url!)
                    
                }catch{
                    print("Open Lock Fail")
                }
            }
            
            DispatchQueue.main.async {
                let image2 = UIImage(named: "unlock.png")
                self.openLockBtn.setImage(image2, for: .normal)
                self.openLockBtn.isEnabled = false
                
                var timer:Timer!
                timer = Timer.scheduledTimer(timeInterval: 3.1, target: self, selector: #selector(self.goLockStatus), userInfo: nil, repeats: false)
                self.addGreyLayer()
                self.addGreenInnerLayerAnimation()
                var btnPressTimeList:NSArray = self.loadBtnRecordList()
                
                
//                while btnPressTimeList.count <= 0 {
//                    usleep(100000)
//                }
            }
        }
    }
    
    
    
    var currentValue:CGFloat? = nil
    
    @objc func goLockStatus(){
        let image = UIImage(named: "lock.png")
        self.openLockBtn.setImage(image, for: .normal)
        //self.openLockBtn.isEnabled = true
        if self.openLockBtn.isEnabled{
            addWhiteLayer()
            addGreenInnerLayer()
        }else{
            
            addGreyLayer()
        }
        
        self.layerChangingStatus = false
        
        
    }
    
    func drawCircle(withColor color: CGColor) -> CAShapeLayer{
        
        var radius:CGFloat = 0
        let paintLineWidth:CGFloat = 9
        //horizental
        
        
        
        if view.frame.size.width > view.frame.size.height {
            
            radius = view.frame.size.height / 2 - 4 * paintLineWidth / 2
            
        }else{
            
            radius = view.frame.size.width / 2 - 4.5 * paintLineWidth / 2
            
        }
        
        
        let shapeLayer = CAShapeLayer()
        let circlePath = UIBezierPath(
            arcCenter: CGPoint(x: view.center.x, y: view.center.y),
            radius: radius,
            startAngle: -90 * CGFloat.pi / 180 ,        //radius
            endAngle: 270 * CGFloat.pi / 180,
            clockwise: true)
        shapeLayer.strokeColor = color
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = paintLineWidth
        shapeLayer.path = circlePath.cgPath
        
        
        
        return shapeLayer
        
        //119 103 69
        
    }
    
    
    func drawCircleOuter(withColor color: CGColor) -> CAShapeLayer{
        
        var radius:CGFloat = 0
        let paintLineWidth:CGFloat = 18
        //horizental
        
        
        
        if view.frame.size.width > view.frame.size.height {
            
            radius = view.frame.size.height / 2 - 2 * paintLineWidth / 2
            
        }else{
            
            radius = view.frame.size.width / 2 - 2 * paintLineWidth / 2
            
        }
        
        
        let shapeLayer = CAShapeLayer()
        let circlePath = UIBezierPath(
            arcCenter: CGPoint(x: view.center.x, y: view.center.y),
            radius: radius,
            startAngle: -90 * CGFloat.pi / 180 ,        //radius
            endAngle: 270 * CGFloat.pi / 180,
            clockwise: true)
        shapeLayer.strokeColor = color
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = paintLineWidth
        shapeLayer.path = circlePath.cgPath
        
        
        
        return shapeLayer
        
        //119 103 69
        
    }
    
    func strokeEndAnimation(to: CGFloat)-> CABasicAnimation {
        
        let ani = CABasicAnimation(keyPath: "strokeEnd")
        ani.duration = 2
        ani.fromValue = 0
        ani.toValue = to / 100.0
        ani.isRemovedOnCompletion = false
        
        ani.fillMode = CAMediaTimingFillMode.forwards
        ani.repeatCount = 0
        
        return ani
    }
    
    func strokeEndAnimationSlow(to: CGFloat)-> CAKeyframeAnimation {
        
        let ani = CAKeyframeAnimation(keyPath: "strokeEnd")
        ani.duration = 3
        
        ani.values = [0, to / 100.0]
        
        ani.timingFunctions = [
            CAMediaTimingFunction(controlPoints: 0.71, 0.67, 0.4, 0.94)
        ]
        //        .17,.67,.4,.92
        
        
        ani.isRemovedOnCompletion = false
        
        ani.fillMode = CAMediaTimingFillMode.forwards
        ani.repeatCount = 0
        
        
        return ani
    }
    
    
    
    func strokeEndAnimationChangeColor(to: CGFloat)-> CAKeyframeAnimation {
        
        let ani = CAKeyframeAnimation(keyPath: "strokeColor")
        ani.duration = 3
        //        if Int(currentValue!) < 30{
        //            ani.values = [UIColor.green.cgColor,UIColor.green.cgColor]
        //        }else if Int(currentValue!) < 60{
        //            ani.values = [UIColor.green.cgColor,UIColor.yellow.cgColor]
        //        }else{
        //
        //            ani.values = [UIColor.green.cgColor,UIColor.red.cgColor]
        //
        //        }
        
        ani.values = [UIColor.green.cgColor,UIColor.green.cgColor]
        
        ani.isRemovedOnCompletion = false
        
        ani.fillMode = CAMediaTimingFillMode.forwards
        ani.repeatCount = 0
        
        return ani
    }
    
    
    
    
    func loadBtnRecordList()->NSArray{
        var btnPressTimeList =  NSArray()
        
        let url = "http://simonhost.hopto.org/chatroom/btnTime.php"
        
        Global.postToURL(url: url, body: "username=\(Global.selfData.username as String)") { (html, data) in
            
            if let jsonData = data {
                do {
                    if html != "Query Error" {
                        btnPressTimeList = []
                        btnPressTimeList = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as! NSArray
                        print("Query OK")
                        self.unlock_vc.queryBtnRecordList()
                        
                    }else {
                        print("Query Fail")
                    }
                    
                } catch {
                    
                    print(error)
                }
            }
        }
        
        //var status: String = ""
        return btnPressTimeList
    }
    
    @IBOutlet weak var label: UILabel!
    var addGreyLayerFlag = false
    func addGreyLayer(){
        let bgColorGrey = UIColor(red: 200/255.0 , green: 200/255.0, blue: 200/255.0, alpha: 1)
        let bgLayerGrey = drawCircleOuter(withColor: bgColorGrey.cgColor)
        bgLayerGrey.name = "LayerGrey";
        view.layer.addSublayer(bgLayerGrey)
        
    }
    
    func addWhiteLayer(){
        let bgColorGrey = UIColor(red: 255/255.0 , green: 255/255.0, blue: 255/255.0, alpha: 1)
        let bgLayerGrey = drawCircleOuter(withColor: bgColorGrey.cgColor)
        bgLayerGrey.name = "LayerWhite";
        view.layer.addSublayer(bgLayerGrey)
        
        
    }
    
    func addGreenInnerLayer(){
        let bgColorGrey = UIColor(red: 0/255.0 , green: 255/255.0, blue: 0/255.0, alpha: 1)
        let bgLayerGrey = drawCircle(withColor:bgColorGrey.cgColor)
        bgLayerGrey.name = "LayerGreen";
        view.layer.addSublayer(bgLayerGrey)
        
        
    }
    
    func addGreenInnerLayerAnimation(){
        
        
        let currentColor = UIColor.green
        let currentLayer = drawCircle(withColor: currentColor.cgColor)
        currentLayer.name = "LayerGreenAni"
        currentLayer.add(strokeEndAnimationSlow(to: 100), forKey: nil)
        
        view.layer.addSublayer(currentLayer)
        
        
    }
    
    
    @objc func rmLayer(){
        for layer in self.view.layer.sublayers!{
            if layer.name == "Layer3", layer.name == "Layer2",layer.name == "Layer1"{
                layer.removeFromSuperlayer()
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        
        
        addGreyLayer()
        
        
        if self.openLockBtn.isEnabled{
            
            addWhiteLayer()
            addGreenInnerLayer()
        }
        
        
        
        //        addGreyLayerFlag = false
        //        currentValue = nil
        //
        //        var timer:Timer!
        //        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(rmLayer), userInfo: nil, repeats: false)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //openLockBtn.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        //openLockBtn.imageView?.contentMode = .scaleAspectFill
        //openLockBtn.imageEdgeInsets = UIEdgeInsetsMake(0,0,100,150);
        //self.view.frame.size.height = self.view.frame.size.width
        //self.view.layer.cornerRadius = self.view.frame.size.width
        
        //label.text = " 請選擇區域 "
        
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
