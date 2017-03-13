//
//  NamedView.swift
//  Animations
//
//  Created by Radi on 3/13/17.
//  Copyright © 2017 Oryx. All rights reserved.
//

import UIKit

class NamedView: UIView {
    
    var besierPaths : [String:UIBezierPath] = [:] {
        didSet {
            setNeedsDisplay()
        }
    }

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        for (_, path) in self.besierPaths {
            path.lineWidth = 2.0
            UIColor.blue.setStroke()
            path.stroke() 
        }
    }
 
}
