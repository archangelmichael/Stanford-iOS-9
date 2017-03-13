//
//  DropView.swift
//  Animations
//
//  Created by Radi on 3/13/17.
//  Copyright © 2017 Oryx. All rights reserved.
//

import UIKit

enum DropMode : Int {
    case normal, hitIt
}

class DropView: UIView, UIDynamicAnimatorDelegate {
    
    var dropMode : DropMode = DropMode.normal
    
    private var drops : [UIView] = []
    
    private lazy var animator : UIDynamicAnimator = {
       let animator = UIDynamicAnimator(referenceView: self)
        animator.delegate = self
        return animator
    }()
    
    func dynamicAnimatorDidPause(_ animator: UIDynamicAnimator) {
        self.removeFullRows()
    }
    
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
        
        if self.dropMode == DropMode.hitIt {
            let dropTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                         action: #selector(removeDrop(recognizer:)))
            drop.addGestureRecognizer(dropTap)
        }

        self.addSubview(drop)
        self.dropBehavior.addItem(item: drop)
        self.drops.append(drop)
    }
    
    func removeDrop(recognizer: UITapGestureRecognizer) -> Void {
        if let drop = recognizer.view {
            for currentDrop in self.drops {
                if currentDrop.backgroundColor == drop.backgroundColor {
                    self.dropBehavior.removeItem(item: currentDrop)
                    currentDrop.removeFromSuperview()
                }
            }
        }
    }
    
    func removeFullRows() -> Void {
        var dropsToRemove : [UIView] = []
        
        var hitTestRect = CGRect(origin: bounds.bottomLeft, size: self.dropSize)
        
        repeat {
            hitTestRect.origin.x = bounds.minX
            hitTestRect.origin.y -= dropSize.height
            
            var dropsTested = 0
            var dropsFound = [UIView]()
            
            while dropsTested < self.dropsPerRow {
                if let hitView = hitTest(p: hitTestRect.mid) {
                    if hitView.superview == self {
                        dropsFound.append(hitView)
                    }
                    else {
                        break
                    }
                }
                else {
                    break
                }
                
                hitTestRect.origin.x += self.dropSize.width
                dropsTested += 1
            }
            
            if dropsTested == self.dropsPerRow {
                dropsToRemove += dropsFound
            }
            
        } while dropsToRemove.count == 0 && hitTestRect.origin.y > bounds.minY
        
        for drop in dropsToRemove {
            self.dropBehavior.removeItem(item: drop)
            drop.removeFromSuperview()
        }
        
    }

}
