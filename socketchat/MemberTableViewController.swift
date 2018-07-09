//
//  MemberTableViewController.swift
//  socketchat
//
//  Created by admin on 2018/7/3.
//  Copyright © 2018年 Simon Chang. All rights reserved.
//

import UIKit

class MemberTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate {
    let url = "http://simonhost.hopto.org/chatroom/selectMemberList.php"
    var settingList = ["Add", "Select", "Delete", "Reload"]
    let selectList = ["Permission"]
    var memberList: [[String:String]] = []
    var radioIsSelected: [Bool] = []
    var permissionTarget: Int? = nil
    var status: String = ""
    var isEdit: Bool = false
    var tabbaritem: UIBarButtonItem!
    var deleteTarget:Set<Int> = []
    var member: [String:String] = [:]
    var myPermission: Int!
    var permissionEditBarButton: UIBarButtonItem!
    let user = UserDefaults()
    
    
    
    @IBOutlet weak var barEditBtn: UIBarButtonItem!
    @IBAction func selectBtn(_ sender: SelectButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func editBtn(_ sender: UIBarButtonItem) {
        
    }
    
    
    func popoverSelectAction(status: String,rightItemTitle: String, cancelAction: Selector? = #selector(cancelButton), editAction: Selector? = nil) {
        
        self.status = status
        let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: cancelAction)
        let EditBarButton = UIBarButtonItem(title: rightItemTitle, style: .plain, target: self, action: editAction)
        navigationItem.leftBarButtonItem = cancelBarButton
        navigationItem.rightBarButtonItem = EditBarButton
        isEdit = true
        tableView.reloadData()
    }
    
    //MARK:- Setting Action
    
    @objc func cancelButton() {
        print(Global.memberData)
        self.isEdit = false
        for i in 0..<self.radioIsSelected.count {
            self.radioIsSelected[i] = false
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        self.navigationItem.rightBarButtonItem = barEditBtn
        barEditBtn.image = UIImage(named: "setting")
        barEditBtn.title = ""
        barEditBtn.isEnabled = true
        self.navigationItem.leftBarButtonItem = nil
        self.status = ""
        self.permissionTarget = nil
        self.deleteTarget = []
    }
    
    @objc func selectButton() {
        
    }
    
    @objc func editPermissionButton() {
        if self.permissionTarget != nil {
            let vc = storyboard?.instantiateViewController(withIdentifier: "permission_vc") as! PermissionSettingViewController
            vc.permission = memberList[permissionTarget!]["mod"]!
            vc.name = memberList[permissionTarget!]["account"]!
            vc.tid = memberList[permissionTarget!]["id"]!
            vc.memberView = self
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @objc func reloadButton() {
        self.isEdit = false
        for i in 0..<self.radioIsSelected.count {
            self.radioIsSelected[i] = false
        }
        DispatchQueue.main.async {
            self.loadMemberList()
            if self.memberList.count != self.radioIsSelected.count {
                self.radioIsSelected = []
                for _ in self.memberList {
                    self.radioIsSelected.append(false)
                }
            }
            self.tableView.reloadData()
        }
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = barEditBtn
        self.status = ""
        self.deleteTarget = []
    }
    
    
    @objc func deleteButton() {
        print("AAA")
        self.isEdit = false
        if self.deleteTarget.count != 0 {
            let deleteurl = "http://simonhost.hopto.org/chatroom/deleteMember.php"
            if self.deleteTarget.count != 0 {
                for i in self.deleteTarget {
                    
                    if myPermission < i {
                        let id = self.memberList[i]["id"] as! String
                        self.postToURL(url: deleteurl, body: "target=\(id)") { (data) in
                            self.loadMemberList()
                            self.radioIsSelected = []
                            for _ in self.memberList {
                                self.radioIsSelected.append(false)
                            }
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    }else {
                        let targetName = self.memberList[i]["username"]
                        self.showAlert(title: "Warning", msg: "you have no permission to delete \(targetName!)", action: nil)
                        self.isEdit = false
                        self.tableView.reloadData()
                    }
                }
                
            }
        }else {
            self.tableView.reloadData()
        }
        self.deleteTarget = []
        
        self.navigationItem.rightBarButtonItem = barEditBtn
        self.navigationItem.leftBarButtonItem = nil
        
    }
    
    @objc func selectRadioAction(sender: SelectButton) {
        switch status {
        case "Add":
            break
        case "Select":
            for i in 0..<radioIsSelected.count {
                if i == sender.radioInRow {
                    permissionTarget = sender.radioInRow
                    radioIsSelected[i] = true
                }else {
                    radioIsSelected[i] = false
                }
                tableView.reloadData()
            }
        case "Delete":
            if sender.isSelected == true {
                deleteTarget.insert(sender.radioInRow)
            }else {
                deleteTarget.remove(sender.radioInRow)
            }
            
        default:
            break
        }
        
    }
    func postToURL(url: String, body: String, action: ((_ returnData: String?) -> Void)? = nil) {
        let postURL = URL(string: url)
        var request = URLRequest(url: postURL!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30)
        request.httpBody = body .data(using: .utf8)
        request.httpMethod = "POST"
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                let html = String(data: data, encoding: .utf8)
                if action != nil {
                    action!(html)
                }
            }
        }
        dataTask.resume()
    }
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SHOW VIEW")
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        DispatchQueue.main.async {
            sleep(2)
            self.member = Global.memberData
            self.myPermission = Int(self.member["mod"]!)
        }
        
        
        loadMemberList()
        
        for _ in memberList {
            radioIsSelected.append(false)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "member_to_popover" {
            let popctrl = segue.destination.popoverPresentationController
            let popview = segue.destination as! PopoverViewController
            popview.memberTable_vc = self
            if sender is UIButton {
                popctrl?.sourceRect = (sender as! UIButton).bounds
                popctrl?.permittedArrowDirections = .down
            }
            
            popctrl?.delegate = self
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
    func loadMemberList() {
        
        if let jsonURL = URL(string: url) {
            do {
                let data = try Data(contentsOf: jsonURL)
                let jsonData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [[String:String]]
                self.memberList = jsonData
                
            } catch {
                print(error)
            }
        }
    }
    
    //MARK: 氣泡框內容
//
//    func showPopView(list: [String]) {
//
//        let height: CGFloat = 44
//
//        let startPoint = CGPoint(x: self.view.frame.width - 30, y: 55)
//        let aView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: (self.view.frame.width) / 3, height: height * CGFloat(list.count)))
//
//        let editTable = addPopListLabel(list: list, size: CGSize(width: aView.frame.width, height: height), startPoint: CGPoint(x: 10, y: 10))
//        for i in editTable {
//            aView.addSubview(i)
//        }
//    }
    
    
    func drawButtonLine( width: CGFloat, height: CGFloat) -> CAShapeLayer {
        
        let shapeLayer = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: 0, y: height))
        linePath.addLine(to: CGPoint(x: width, y: height))
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 0.5
        shapeLayer.path = linePath.cgPath
        
        return shapeLayer
    }
    
    func showAlert(title: String, msg: String , action: ((UIAlertAction) -> Void)?) {
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let OK = UIAlertAction(title: "OK", style: .cancel, handler: action)
        alert.addAction(OK)
        self.present(alert,animated: true,completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return memberList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let nameLabel = cell.viewWithTag(10) as! UILabel
        let selectRadio = cell.viewWithTag(20) as! SelectButton
        
        selectRadio.isSelected = radioIsSelected[indexPath.row]
        selectRadio.radioInRow = indexPath.row
        
        
        if isEdit == true {
            for i in cell.contentView.constraints {
                if i.identifier == "radio_btn_constraint" {
                    i.constant = 5
                    UIView.animate(withDuration: 0.5) {
                        self.view.layoutIfNeeded()
                    }
                }
            }
        }else {
            for i in cell.contentView.constraints {
                if i.identifier == "radio_btn_constraint" {
                    i.constant = -22
                    UIView.animate(withDuration: 0.5) {
                        self.view.layoutIfNeeded()
                    }
                }
            }
        }
        
        selectRadio.addTarget(self, action: #selector(selectRadioAction(sender:)), for: .touchUpInside)
        nameLabel.text = memberList[indexPath.row]["username"]
        
        // Configure the cell...
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
