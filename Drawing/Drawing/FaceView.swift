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
    let lineWidth : CGFloat = 2.0
    let eyeRadius : CGFloat = 10.0

    private var faceRadius : CGFloat {
        return min(bounds.size.height, bounds.size.width)/2 * scale
    }
    
    private var faceCenter : CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    private func pathForCircleAt(center: CGPoint, radius: CGFloat) -> UIBezierPath {
        let path = UIBezierPath(arcCenter: center,
                     radius: radius,
                     startAngle: CGFloat(0) ,
                     endAngle: CGFloat(2 * M_PI),
                     clockwise: true)
        path.lineWidth = lineWidth
        return path
    }
    
    override func draw(_ rect: CGRect) {
        
        let face = self.pathForCircleAt(center: faceCenter, radius: faceRadius)
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
        let leftEye = self.pathForCircleAt(center: leftEyeCenter, radius: eyeRadius)
        UIColor.blue.setStroke()
        leftEye.stroke()
        
        let rightEyeCenter = CGPoint(x: 4/3 * faceCenter.x,
                                    y: 2/3 * faceCenter.y)
        let rightEye =  self.pathForCircleAt(center: rightEyeCenter, radius: eyeRadius)
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
