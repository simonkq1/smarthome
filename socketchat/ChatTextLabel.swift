//
//  ChatTextLabel.swift
//  socketchat
//
//  Created by admin on 2018/6/29.
//  Copyright © 2018年 Simon Chang. All rights reserved.
//

import UIKit

class ChatTextLabel: UILabel {
    
    override func awakeFromNib() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
        layer.cornerRadius = 5
        
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
