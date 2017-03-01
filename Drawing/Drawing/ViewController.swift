//
//  ViewController.swift
//  Drawing
//
//  Created by Radi on 3/1/17.
//  Copyright © 2017 Oryx. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var triangle1: Triangle!
    var triangle2: Triangle!
    var triangle3: Triangle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.triangle1 = Triangle(frame: CGRect(x: 50, y: 50, width: 200, height: 200),
                                 stroke: UIColor.red,
                                 fill: UIColor.blue)
        self.view.addSubview(self.triangle1)
        self.triangle1.rotate360Degrees()
        
        
        self.triangle2 = Triangle(frame: CGRect(x: 50, y: 300, width: 100, height: 200),
                                 stroke: UIColor.green,
                                 fill: UIColor.yellow)
        self.view.addSubview(self.triangle2)
        self.triangle2.rotate360Degrees()
        
        
        self.triangle3 = Triangle(frame: CGRect(x: 150, y: 300, width: 200, height: 100),
                                 stroke: UIColor.blue,
                                 fill: UIColor.red)
        self.view.addSubview(self.triangle3)
        self.triangle3.rotate360Degrees()
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

