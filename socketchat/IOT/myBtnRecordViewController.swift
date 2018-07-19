//
//  myBtnRecordViewController.swift
//  socketchat
//
//  Created by Yen on 2018/7/18.
//  Copyright © 2018年 Simon Chang. All rights reserved.
//

import UIKit

class myBtnRecordViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var btnPressTimeList =  NSArray()
    override func viewWillAppear(_ animated: Bool) {
        btnPressTimeList = []
        btnPressTimeList = queryBtnRecordList();
        
        
        
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //        let backItem = UIBarButtonItem()
        //        backItem.title = "首頁jlkj"
        //        navigationItem.backBarButtonItem = backItem
        
        // Do any additional setup after loading the view.
        
        
        //        let barBtn = UIBarButtonItem(title: "AAA", style: .plain, target: self, action: #selector(backAction))
        
    }
    
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return btnPressTimeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        (cell.viewWithTag(100) as! UILabel).text =  ((btnPressTimeList[indexPath.row] as! NSDictionary)["username"] as! String)
        (cell.viewWithTag(200) as! UILabel).text =  ((btnPressTimeList[indexPath.row] as! NSDictionary)["time"] as! String)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    //    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //        return "開鎖人員           開鎖時間"
    //    }
    
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header:UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        
        header.textLabel?.textColor = UIColor.black
        header.textLabel?.font = UIFont.systemFont(ofSize: 20.0)
        header.textLabel?.frame = header.frame
        header.textLabel?.textAlignment = NSTextAlignment.center
    }
    
    // MARK: - set the headerheight into zero
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    
    //MARK: query unlockButton Time from mysql
    func queryBtnRecordList()->NSArray{
        var btnPressTimeList =  NSArray()
        let url = "http://simonhost.hopto.org/chatroom/btnQueryTime.php"
        
        //var status: String = ""
        if let jsonURL = URL(string: url) {
            do {
                let data = try Data(contentsOf: jsonURL)
                if String(data: data, encoding: .utf8) != "Query Error" {
                    btnPressTimeList = []
                    btnPressTimeList = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSArray
                    print("Query OK")
                    
                }else {
                    print("Query Fail")
                }
                
            } catch {
                
                print(error)
            }
        }
        return btnPressTimeList
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
