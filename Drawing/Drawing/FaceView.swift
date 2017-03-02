//
//  FaceView.swift
//  Drawing
//
//  Created by Radi on 3/1/17.
//  Copyright © 2017 Oryx. All rights reserved.
//

import UIKit

@IBDesignable
class FaceView: UIView {
    
    private let angleMultiplier : CGFloat = 1/sqrt(2)
    
    @IBInspectable
    var scale : CGFloat = 0.8 { didSet { setNeedsDisplay() } }
    
    @IBInspectable
    var lineWidth : CGFloat = 2.0 { didSet { setNeedsDisplay() } }
    @IBInspectable
    var eyeRadiusOffset : CGFloat = 0.3{ didSet { setNeedsDisplay() } }
    @IBInspectable
    var eyeCenterOffset : CGFloat = 0.3{ didSet { setNeedsDisplay() } }
    private var mouthOffset : CGFloat = 0.5
    
    @IBInspectable
    var fillColor : UIColor = UIColor.green{ didSet { setNeedsDisplay() } }
    @IBInspectable
    var strokeColor : UIColor = UIColor.blue{ didSet { setNeedsDisplay() } }
    @IBInspectable
    var mouthState : Int = 0 { didSet { setNeedsDisplay() } } // 1 - smile, 0 - normal, -1 - fraun
    
    private var faceRadius : CGFloat {
        return min(bounds.size.height, bounds.size.width)/2 * scale
    }
    
    private var eyeRadius : CGFloat {
        return eyeCenterDistance * eyeRadiusOffset
    }
    
    private var eyeCenterDistance : CGFloat {
        return faceRadius * eyeCenterOffset
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
    
    private func pathForMouthAt() -> UIBezierPath {
        var path : UIBezierPath
        switch mouthState {
        case 1: // Smile
            path = UIBezierPath(arcCenter: faceCenter,
                                radius: faceRadius * mouthOffset,
                                startAngle: CGFloat(1/4 * M_PI),
                                endAngle: CGFloat(3/4 * M_PI),
                                clockwise: true)
            break
        case -1: // Fraun
            path = UIBezierPath(arcCenter: CGPoint(x: faceCenter.x,
                                                   y: faceCenter.y + faceRadius),
                                radius: faceRadius * mouthOffset,
                                startAngle: CGFloat(-1/4 * M_PI),
                                endAngle: CGFloat(-3/4 * M_PI),
                                clockwise: false)
            break
        default: // Normal
            path = UIBezierPath()
            path.move(to: CGPoint(x: faceCenter.x - angleMultiplier * faceRadius * mouthOffset,
                                  y: faceCenter.y + angleMultiplier * faceRadius * mouthOffset))
            path.addLine(to: CGPoint(x: faceCenter.x + angleMultiplier * faceRadius * mouthOffset,
                                     y: faceCenter.y + angleMultiplier * faceRadius * mouthOffset))
            break
        }
        
        path.lineWidth = lineWidth
        return path
    }
    
    override func draw(_ rect: CGRect) {
        
        let face = self.pathForCircleAt(center: faceCenter, radius: faceRadius)
        fillColor.setFill()
        face.fill()
        
        let mouth = pathForMouthAt()
        strokeColor.setStroke()
        mouth.stroke()
        
        let leftEyeCenter = CGPoint(x: faceCenter.x - angleMultiplier * eyeCenterDistance,
                                    y: faceCenter.y - angleMultiplier * eyeCenterDistance)
        let leftEye = self.pathForCircleAt(center: leftEyeCenter, radius: eyeRadius)
        strokeColor.setStroke()
        leftEye.stroke()
        
        let rightEyeCenter = CGPoint(x: faceCenter.x + angleMultiplier * eyeCenterDistance,
                                     y: faceCenter.y - angleMultiplier * eyeCenterDistance)
        let rightEye =  self.pathForCircleAt(center: rightEyeCenter, radius: eyeRadius)
        strokeColor.setStroke()
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
