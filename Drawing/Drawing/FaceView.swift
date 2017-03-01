//
//  FaceView.swift
//  Drawing
//
//  Created by Radi on 3/1/17.
//  Copyright © 2017 Oryx. All rights reserved.
//

import UIKit

class FaceView: UIView {
    let scale : CGFloat = 0.8

    var faceRadius : CGFloat {
        return min(bounds.size.height, bounds.size.width)/2 * scale
    }
    var faceCenter : CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    override func draw(_ rect: CGRect) {
        
        let face = UIBezierPath(arcCenter: faceCenter,
                                 radius: faceRadius,
                                 startAngle: CGFloat(0) ,
                                 endAngle: CGFloat(2 * M_PI),
                                 clockwise: true )
        
        face.lineWidth = 2.0
        UIColor.green.setFill()
        face.fill()
        
        
        let mouth = UIBezierPath(arcCenter: faceCenter,
                                 radius: faceRadius * 2 / 3,
                                 startAngle: CGFloat(1/4 * M_PI),
                                 endAngle: CGFloat(3/4 * M_PI),
                                 clockwise: true)
        mouth.lineWidth = 2.0
        UIColor.blue.setStroke()
        mouth.stroke()
        
        let leftEyeCenter = CGPoint(x: 2/3 * faceCenter.x,
                                    y: 2/3 * faceCenter.y)
        let leftEye =  UIBezierPath(arcCenter: leftEyeCenter,
                                    radius: 10,
                                    startAngle: CGFloat(0) ,
                                    endAngle: CGFloat(2 * M_PI),
                                    clockwise: true )
        leftEye.lineWidth = 2.0
        UIColor.blue.setStroke()
        leftEye.stroke()
        
        let rightEyeCenter = CGPoint(x: 4/3 * faceCenter.x,
                                    y: 2/3 * faceCenter.y)
        let rightEye =  UIBezierPath(arcCenter: rightEyeCenter,
                                    radius: 10,
                                    startAngle: CGFloat(0) ,
                                    endAngle: CGFloat(2 * M_PI),
                                    clockwise: true )
        rightEye.lineWidth = 2.0
        UIColor.blue.setStroke()
        rightEye.stroke()

        
    }
    

    static func drawFace(vc : UIViewController) {
        let width = vc.view.frame.size.width
        let height = vc.view.frame.size.height
        let max = min(width, height)
        var faceRect = CGRect(x: 0, y: 0, width: max, height: max)
        if width >= height {
            faceRect = CGRect(x: (width - max)/2, y: 0, width: max, height: max)
        }
        else {
            faceRect = CGRect(x: 0, y: (height - max)/2, width: max, height: max)
        }
        
        let face = FaceView(frame: faceRect)
        vc.view.addSubview(face)
        face.backgroundColor = UIColor.clear
    }
}
