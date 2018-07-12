//
//  BottomBorderTextField.swift
//  socketchat
//
//  Created by admin on 2018/7/12.
//  Copyright © 2018年 Simon Chang. All rights reserved.
//

import UIKit

class BottomBorderTextField: UITextField {
    override func awakeFromNib() {
        self.borderStyle = .none
        let shapeLayer = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: 0, y: self.bounds.height))
        linePath.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height))
        
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.path = linePath.cgPath
        self.layer.addSublayer(shapeLayer)
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
