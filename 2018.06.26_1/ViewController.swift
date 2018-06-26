//
//  ViewController.swift
//  2018.06.26_1
//
//  Created by admin on 2018/6/26.
//  Copyright © 2018年 Simon Chang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var isStream: InputStream? = nil
    var outStream: OutputStream? = nil
    var jsonObject: [String:Any] = [:]
    var chatData: [[String:Any]] = []

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var speakText: UITextField!
    @IBAction func sendBtn(_ sender: Any) {
        if let text = speakText.text {
            send(text)
            speakText.text = ""
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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
                        var strDate = Date()
                        if !chatString.contains("naflqknflqwnfiqwnfoivnqwilncfqoiwncionqwiondi120ue1902ue09qwndi12y4891y284!@#!@#!@ED,qwiojndjioqwndioclqn21#!@") {
                            
                                self.chatData.append(["sender":chatSender,"string":chatString,"date":Date()])
                                    strDate = Date()
                                self.tableView.reloadData()
                                print(self.chatData)
                            
                        }
                    }
                }
            })
        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.global().async {
            while true{
                sleep(15)
                self.send("naflqknflqwnfiqwnfoivnqwilncfqoiwncionqwiondi120ue1902ue09qwndi12y4891y284!@#!@#!@ED,qwiojndjioqwndioclqn21#!@")
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return chatData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let sender = chatData[indexPath.row]["sender"] as! String
        let string = chatData[indexPath.row]["string"] as! String
        let date = chatData[indexPath.row]["date"] as! Date
        print(string)
        print(chatData)
        cell.textLabel?.text = sender
        cell.detailTextLabel?.text = string
        tableView.separatorColor = UIColor.clear
        
        // Configure the cell...
        
        return cell
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


}

