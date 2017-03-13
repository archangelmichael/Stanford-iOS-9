//
//  DropView.swift
//  Animations
//
//  Created by Radi on 3/13/17.
//  Copyright © 2017 Oryx. All rights reserved.
//

import UIKit

class DropView: UIView {
    
    private lazy var animator : UIDynamicAnimator = UIDynamicAnimator(referenceView: self)
    
    private let dropBehavior = DropBehavior()
    
    var animating : Bool = false {
        didSet {
            if self.animating {
                self.animator.addBehavior(self.dropBehavior)
            }
            else {
                self.animator.removeBehavior(self.dropBehavior)
            }
        }
    }

    private let dropsPerRow = 10
    
    private var dropSize : CGSize {
        let size = bounds.size.width / CGFloat(self.dropsPerRow)
        return CGSize(width: size, height: size)
    }
    
    func addDrop() -> Void {
        var frame = CGRect(origin: .zero, size: self.dropSize)
        frame.origin.x = CGFloat.random(max: self.dropsPerRow) * self.dropSize.width
        let drop = UIView(frame: frame)
        drop.backgroundColor = UIColor.random
        self.addSubview(drop)
        
        self.dropBehavior.addItem(item: drop)
    }

}
