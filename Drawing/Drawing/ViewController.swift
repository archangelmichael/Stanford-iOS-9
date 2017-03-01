//
//  ViewController.swift
//  Drawing
//
//  Created by Radi on 3/1/17.
//  Copyright © 2017 Oryx. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
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

