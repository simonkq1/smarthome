//
//  TestViewController.swift
//  socketchat
//
//  Created by Simon on 2018/7/18.
//  Copyright © 2018年 Simon Chang. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.navigationBar.isTranslucent = false
//        self.navigationController?.navigationBar.backgroundColor = UIColor.blue
        
        let image = UIImage(named: "people")
//        self.navigationController?.navigationBar.setBackgroundImage(image?.resizeImage(imagepoint: 32).resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), resizingMode: .stretch), for: .default)
        
        let newimage = image?.resizeImage(imagepoint: 1024)
        let imdata = newimage!.pngData()?.base64EncodedData()
        let a = String(data: imdata!, encoding: .utf8)
        let b = Data(base64Encoded: a!)
        imageView.image = UIImage(data: b!)
        topImageView.image = getDataImage(image: image!, imagepoint: 32)
        topImageView.alpha = 0.5
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
    }
    
    func getDataImage(image:UIImage, imagepoint: CGFloat) -> UIImage {
        
        let newimage = image.resizeImage(imagepoint: imagepoint)
        let imdata = newimage.pngData()?.base64EncodedData()
        let a = String(data: imdata!, encoding: .utf8)
        let b = Data(base64Encoded: a!)
        let finishImage = UIImage(data: b!)
        return finishImage!
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
