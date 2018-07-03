//
//  MemberTableViewController.swift
//  socketchat
//
//  Created by admin on 2018/7/3.
//  Copyright © 2018年 Simon Chang. All rights reserved.
//

import UIKit
import Popover

class MemberTableViewController: UITableViewController {
    let url = "http://simonhost.hopto.org/chatroom/selectMemberList.php"
    let list = ["A", "B", "C"]
    let listStr = ["Add", "Select", "Delete"]
    var memberList: [[String:String]] = []
    var radioIsSelected: [Bool] = []
    var status: String = ""
    var isEdit: Bool = false
    let popover = Popover()
    var tabbaritem: UIBarButtonItem!
    
    
    
    
    @IBOutlet weak var barEditBtn: UIBarButtonItem!
    @IBAction func selectBtn(_ sender: SelectButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func editBtn(_ sender: Any) {
        
        let height: CGFloat = 44
        let startPoint = CGPoint(x: self.view.frame.width - 30, y: 55)
        let aView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: (self.view.frame.width) / 3, height: height * CGFloat(listStr.count)))
        
        let editTable = addPopListLabel(list: listStr, size: CGSize(width: aView.frame.width, height: height), startPoint: CGPoint(x: 10, y: 10))
        for i in editTable {
            aView.addSubview(i)
        }
//        aView.addSubview(edittableView.view)
        
        popover.show(aView, point: startPoint)
    }
    
    
    @IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
        let tapview = sender.view
        let textLabel = tapview?.viewWithTag(10) as! UILabel
        switch textLabel.text {
        case listStr[0]:
            print("A")
        case listStr[1]:
            status = listStr[1]
            let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButton))
            let EditBarButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editButton))
            navigationItem.leftBarButtonItem = cancelBarButton
            navigationItem.rightBarButtonItem = EditBarButton
            isEdit = true
            tableView.reloadData()
            self.popover.dismiss()
        case listStr[2]:
            isEdit = true
            tableView.reloadData()
            self.popover.dismiss()
        default:
            break
        }
        
    }
    
    @objc func cancelButton() {
        isEdit = false
        tableView.reloadData()
        navigationItem.leftBarButtonItem = nil
        navigationItem.rightBarButtonItem = editButtonItem
        editButtonItem.image = UIImage(named: "setting")
        editButtonItem.action = #selector(editBtn(_:))
        print("cancel")
    }
    
    @objc func editButton() {
        isEdit = false
        tableView.reloadData()
        navigationItem.rightBarButtonItem = editButtonItem
        navigationItem.leftBarButtonItem = nil
        editButtonItem.image = UIImage(named: "setting")
        editButtonItem.action = #selector(editBtn(_:))
        print("cancel")
    }
    
    @objc func selectRadioAction(sender: UIButton) {
        
        
//        print(sender.tag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        tabbaritem = editButtonItem
        if let jsonURL = URL(string: url) {
            do {
                let data = try Data(contentsOf: jsonURL)
                let jsonData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [[String:String]]
                memberList = jsonData
                //                print(jsonData)
                
            } catch {
                print(error)
            }
        }
        
        for _ in memberList {
            radioIsSelected.append(false)
        }
        print(radioIsSelected)
        
    }
    
    func addPopListLabel(list: [String], size: CGSize, startPoint: CGPoint) -> [UIView] {
        var labelArray: [UILabel] = []
        var viewArr: [UIView] = []
        for i in 0..<list.count {
            let textLayer = UILabel()
            let viewObject = UIView()
            viewObject.frame.size = size
            viewObject.frame.origin = CGPoint(x: 0, y: 10 + size.height * CGFloat(i))
            textLayer.text = list[i]
            
            textLayer.frame.size = size
            textLayer.frame.origin = CGPoint(x: 0, y: 0)
            textLayer.textColor = UIColor.black
            textLayer.font = UIFont(name: "System", size: 15)
//            textLayer.layer.borderWidth = 1
            textLayer.textAlignment = .center
            textLayer.tag = 10

            viewArr.append(viewObject)
            labelArray.append(textLayer)
            viewObject.addSubview(textLayer)
            viewObject.tag = i + 1
            if viewObject.tag < listStr.count {
                viewObject.layer.addSublayer(drawButtonLine(width: size.width, height: size.height))
            }
            
            viewObject.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapGesture(_:))))
//            print(textLayer.frame.origin)
        }
        return viewArr
    }
    
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
        let selectRadio = cell.viewWithTag(20) as! UIButton
        selectRadio.isSelected = radioIsSelected[indexPath.row]
        
        
        
        if isEdit == true {
            for i in cell.contentView.constraints {
                if i.identifier == "radio_btn_constraint" {
                    i.constant = 1
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
        
        nameLabel.text = memberList[indexPath.row]["account"]
        
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
