//
//  MessageBoardTableViewCell.swift
//  socketchat
//
//  Created by admin on 2018/7/9.
//  Copyright © 2018年 Simon Chang. All rights reserved.
//

import UIKit

class MessageBoardTableViewCell: UITableViewCell {

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var boardView: UIView!
    @IBOutlet weak var bottom_left_label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        bottom_left_label.drawUpperLine()
        boardView.layer.borderWidth = 0.5
        boardView.layer.cornerRadius = 5
        bottom_left_label.textColor = UIColor(red: 115/255, green: 115/255, blue: 115/255, alpha: 0.7)
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
