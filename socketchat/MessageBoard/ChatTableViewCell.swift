//
//  ChatTableViewCell.swift
//  socketchat
//
//  Created by admin on 2018/7/10.
//  Copyright © 2018年 Simon Chang. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var contextLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        timeLabel.textColor = UIColor(red: 115/255, green: 115/255, blue: 115/255, alpha: 0.7)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
