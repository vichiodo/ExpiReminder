//
//  BarCodeView.swift
//  BarScannerReaderSwift
//
//  Created by Rafael  Hieda on 30/06/15.
//  Copyright (c) 2015 Rafael Hieda. All rights reserved.
//

import UIKit

class BarCodeView: UIView {

    var borderLayer: CAShapeLayer?
    var corners: [CGPoint]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setMyView()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func drawBorder(points: [CGPoint]) {
        self.corners = points
        let path =  UIBezierPath()
        
        //println(points)
        path.moveToPoint(points.first!)
        for (var i = 1; i < points.count; i++) {
            path.addLineToPoint(points[i])
        }
        path.addLineToPoint(points.first!)
        borderLayer?.path = path.CGPath
        
    }
    
    func setMyView() {
        borderLayer = CAShapeLayer()
        borderLayer?.strokeColor = UIColor.greenColor().CGColor
        borderLayer?.lineWidth = 2.0
        borderLayer?.fillColor = UIColor.clearColor().CGColor
        self.layer.addSublayer(borderLayer)
    }
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
