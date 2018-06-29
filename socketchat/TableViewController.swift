//
//  TableViewController.swift
//  2018.06.26_1
//
//  Created by admin on 2018/6/26.
//  Copyright © 2018年 Simon Chang. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    let list = ["aa","aa","aa"]
    var isStream: InputStream? = nil
    var outStream: OutputStream? = nil
    var jsonObject: [String:Any] = [:]
    var chatData: [[String:Any]] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableView.separatorColor = UIColor.clear
        
        //MARK:- --- socket連線 ---
        let _ = Stream.getStreamsToHost(withName: "localhost", port: 5000, inputStream: &isStream, outputStream: &outStream)
        isStream?.open()
        outStream?.open()
        
        
        DispatchQueue.global().async {
            self.receiveData(avaliable: { (data) in
                DispatchQueue.main.async {
                    if let _ = data {
                        let chatString = data!["data"] as! String
                        let chatSender = data!["sender"] as! String
                        if !chatString.contains("naflqknflqwnfiqwnfoivnqwilncfqoiwncionqwiondi120ue1902ue09qwndi12y4891y284!@#!@#!@ED,qwiojndjioqwndioclqn21#!@") {
                            self.chatData.append(["sender":chatSender,"string":chatString,"date":Date()])
                            self.tableView.reloadData()
                        }
                    }
                }
            })
        }
        
    }
    
    func receiveData(avaliable: (_ data: [String:Any]?) -> Void) {
        var buf = Array(repeating: UInt8(0), count: 1024)
        
        while true {
            if let n = isStream?.read(&buf, maxLength: 1024) {
                let data = Data(bytes: buf, count: n)
                do{
                    jsonObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String : Any]
                    //                    print(jsonObject)
                }catch{
                    print(error)
                }
                
                NSLog(jsonObject["data"] as! String)
                avaliable(jsonObject)
            }
        }
    }
    
    func send(_ string: String) {
        var buf = Array(repeating: UInt8(0), count: 1024)
        var data = string.data(using: .utf8)!
        
        data.copyBytes(to: &buf, count: data.count)
        outStream?.write(buf, maxLength: data.count)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return chatData.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return chatData[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let sender = chatData[indexPath.section]["sender"] as! String
        let string = chatData[indexPath.section]["string"] as! String
        let date = chatData[indexPath.section]["date"]
        cell.textLabel?.text = sender
        cell.detailTextLabel?.text = string
        tableView.separatorColor = UIColor.clear

        // Configure the cell...

        return cell
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.global().async {
            while true{
                sleep(5)
                self.send("naflqknflqwnfiqwnfoivnqwilncfqoiwncionqwiondi120ue1902ue09qwndi12y4891y284!@#!@#!@ED,qwiojndjioqwndioclqn21#!@")
            }
        }
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
