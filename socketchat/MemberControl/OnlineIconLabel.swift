//
//  OnlineIconLabel.swift
//  socketchat
//
//  Created by Simon on 2018/7/17.
//  Copyright © 2018年 Simon Chang. All rights reserved.
//

import UIKit

class OnlineIconLabel: UILabel {
    let shapeLayer = CAShapeLayer()
    let linePath = UIBezierPath()
    
    var isOnline: Bool = false {
        didSet {
            strokeColor()
        }
    }
    
    override func awakeFromNib() {
        drawOnlineIcon()
    }
    
    private func strokeColor() {
        shapeLayer.strokeColor = (isOnline == true) ? UIColor.green.cgColor : UIColor.lightGray.cgColor
        shapeLayer.fillColor = (isOnline == true) ? UIColor.green.cgColor : UIColor.lightGray.cgColor
    }
    
    func drawOnlineIcon() {
        let width = self.bounds.size.width
        let height = self.bounds.size.height
        let lineWidth: CGFloat = 1
        let radius: CGFloat = 5
        linePath.addArc(
            withCenter: CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2),
            radius: radius,
            startAngle: 0,
            endAngle: 2 * CGFloat.pi,
            clockwise: true)
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
