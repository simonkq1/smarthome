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
//        let height = frame.size.height
//        let width = frame.size.width
//        let myX = frame.origin.x
//        let myY = frame.origin.y
//        let maxY = frame.maxY
////        let centerY = center.y
//
//        let angLayer = CAShapeLayer()
//        let linePath = UIBezierPath()
//        linePath.move(to: CGPoint(x: myX + width, y: myY + 4))
//        linePath.addLine(to: CGPoint(x: myX + width + 5, y: myY + 9))
//        linePath.addLine(to: CGPoint(x: myX + width, y: myY + 14))
//
//
//        linePath.close()
//        angLayer.strokeColor = UIColor.lightGray.cgColor
//        angLayer.fillColor = UIColor.white.cgColor
//        angLayer.cov
//        
//        angLayer.path = linePath.cgPath
//
//        superview?.layer.addSublayer(angLayer)
//
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
