//
//  SettingViewController.swift
//  socketchat
//
//  Created by Simon on 2018/7/18.
//  Copyright © 2018年 Simon Chang. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var accountLabel: UILabel!
    var list:[String] = ["暱稱","權限","更換名稱","更換照片","登出"]
    var image: UIImage!
    var myImage: UIImage!
    let user = UserDefaults()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        userNameLabel.text = Global.selfData.username as! String
        accountLabel.text = "帳號: \(Global.selfData.account as! String)"
        accountLabel.font = UIFont.boldSystemFont(ofSize: 15)
        accountLabel.textColor = UIColor(red: 177/255, green: 177/255, blue: 177/255, alpha: 1)
        tableView.tableFooterView = UIView()
        
        //        self.navigationController?.navigationBar.setBackgroundImage(image?.resizeImage(imagepoint: 32).resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), resizingMode: .stretch), for: .default)
        if Global.selfData.image == "default" {
            image = UIImage(named: "people")
            imageView.image = image.resizeImage(imagepoint: 256)
            topImageView.image = image.resizeImage(imagepoint: 64)
        }else {
            let imageStr = Global.selfData.image
            let imageData = Data(base64Encoded: imageStr!)
            image = UIImage(data: imageData!)
            imageView.image = image
            topImageView.image = image.resizeImage(imagepoint: 64)
        }
        
        topImageView.alpha = 0.5
    }
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
    }
    
    
    
    func getDataImage(image:UIImage, imagepoint: CGFloat) -> UIImage {
        
        let newimage = image.resizeImage(imagepoint: imagepoint)
        let imdata = UIImagePNGRepresentation(newimage)?.base64EncodedData()
        let a = String(data: imdata!, encoding: .utf8)
        let b = Data(base64Encoded: a!)
        let finishImage = UIImage(data: b!)
        return finishImage!
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let updateImageURL = "http://simonhost.hopto.org/chatroom/updateUserImage.php"
        let tmp_image = info[UIImagePickerControllerOriginalImage] as! UIImage
        myImage = tmp_image.resizeImage(imagepoint: 64)
        let finIm = tmp_image.resizeImage(imagepoint: 512)
        let imageStr = tmp_image.changeImageToBase64String(resize: 512)
        Global.postToURL(url: updateImageURL, body: "tid=\(Global.selfData.id as! String)&image=\(imageStr)") { (string, data) in
            if string == "0" {
                DispatchQueue.main.async {
                    self.imageView.image = finIm
                    self.topImageView.image = self.myImage
                    Global.selfData.image = imageStr
                    picker.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    func imageChange() {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.sourceType = .photoLibrary
        imagePickerVC.delegate = self
        
        imagePickerVC.modalPresentationStyle = .fullScreen
        show(imagePickerVC, sender: self)
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//        if list.count - 1 > indexPath.row {
//            cell.contentView.drawborder(firstIndex: 20, width: 0.8, color: UIColor.gray, sides: [.down])
//        }
        cell.detailTextLabel?.text = ""
        
        switch list[indexPath.row] {
            
        case "暱稱":
            cell.detailTextLabel?.text = Global.selfData.username as! String
            break
        case "權限":
            cell.detailTextLabel?.text = Global.selfData.permission as! String
            break
        case "登出":
            break
        default:
            cell.accessoryType = .disclosureIndicator
        }
        if indexPath.row >= 2 {
            cell.detailTextLabel?.textColor = UIColor.black
        }else {
            cell.detailTextLabel?.textColor = UIColor(red: 144/255, green: 144/255, blue: 144/255, alpha: 1)
        }
       
        cell.textLabel?.text = list[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch list[indexPath.row] {
        case "更換照片":
            imageChange()
            break
        case "更換名稱":
            let vc = storyboard?.instantiateViewController(withIdentifier: "updatename_vc") as! UpdateUserNameViewController
            DispatchQueue.main.async {
                vc.nameTextField.text = Global.selfData.username as! String
                vc.setting_vc = self
            }
            show(vc, sender: self)
            
        default:
            break
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 6
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let fv = view as! UITableViewHeaderFooterView
        let color = UIColor.clear
        fv.contentView.layer.backgroundColor = color.cgColor
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
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
