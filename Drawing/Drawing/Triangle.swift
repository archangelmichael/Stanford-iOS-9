//
//  Triangle.swift
//  Drawing
//
//  Created by Radi on 3/1/17.
//  Copyright © 2017 Oryx. All rights reserved.
//

import UIKit

class Triangle: UIView {
    
    var strokeColor : UIColor = UIColor.white
    var fillColor : UIColor = UIColor.white

    convenience init(frame: CGRect, stroke: UIColor, fill: UIColor) {
        self.init(frame: frame)
        self.strokeColor = stroke
        self.fillColor = fill
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        
        // Rect center coordinates
        let centerX = rect.width/2
        let centerY = rect.height/2
    
        let path = UIBezierPath()
        path.lineWidth = 2.0
        
        var rectSide = min(rect.width, rect.height)
        var offset : CGFloat = 0.0
        if rect.width >= rect.height {
            rectSide = rect.height
            offset = 0.0
        }
        else {
            rectSide = rect.width
            offset = (rect.height - rect.width) / CGFloat(2.0)
        }
        
        let pointA = CGPoint(x: centerX, y: offset)
        let pointB = CGPoint(x: centerX + sqrt(3) * rectSide / 4,
                         y: centerY + rectSide / 4)
        let pointC = CGPoint(x: centerX - sqrt(3) * rectSide / 4,
                         y: centerY + rectSide / 4)
        
        path.move(to: pointA)
        path.addLine(to: pointB)
        path.addLine(to: pointC)
        path.close()
        
        self.strokeColor.setStroke()
        self.fillColor.setFill()
        
        path.stroke()
        path.fill()
    }

}
