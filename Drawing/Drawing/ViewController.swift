//
//  ViewController.swift
//  Drawing
//
//  Created by Radi on 3/1/17.
//  Copyright © 2017 Oryx. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var faceView: FaceView! {
        didSet {
            let panGesture : UIPanGestureRecognizer = UIPanGestureRecognizer(
                target: self,
                action: #selector(ViewController.pan(gesture:))
            )
            
            self.faceView.addGestureRecognizer(panGesture)
            
            let pinchGesture : UIPinchGestureRecognizer = UIPinchGestureRecognizer(
                target: self,
                action: #selector(ViewController.pinch(gesture:))
            )
            
            self.faceView.addGestureRecognizer(pinchGesture)
        }
    }
    
    func pan(gesture: UIPanGestureRecognizer) -> Void {
        switch gesture.state {
        case .changed:
            let translation = gesture.translation(in: self.faceView)
            self.moveFaceWith(translation: translation)
            self.faceView.mouthState = 1
            break
        case .ended:
            let translation = gesture.translation(in: self.faceView)
            self.moveFaceWith(translation: translation)
            self.faceView.mouthState = 0
            break
        default:
            break
        }
        
        gesture.setTranslation(CGPoint.zero, in: self.faceView)
    }
    
    func moveFaceWith(translation: CGPoint) -> Void {
        self.faceView.center = CGPoint(x: self.faceView.center.x + translation.x,
                                       y: self.faceView.center.y + translation.y)
    }
    
    func pinch(gesture: UIPinchGestureRecognizer) -> Void {
        switch gesture.state {
        case .changed,
             .ended:
            let scale = gesture.scale
            self.faceView.scale *= scale
            gesture.scale = 1.0
            break
        default:
            break
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Triangle.drawRotatingTriangles(vc: self)
        
//        Face.drawFace(vc: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension UIView {
    func rotate360Degrees(duration: CFTimeInterval = 1.0, completionDelegate: CAAnimationDelegate? = nil) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.repeatDuration = 30.0
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(M_PI * 2.0)
        rotateAnimation.duration = duration
        
        if let delegate: CAAnimationDelegate = completionDelegate {
            rotateAnimation.delegate = delegate
        }
        
        self.layer.add(rotateAnimation, forKey: nil)
    }
}

