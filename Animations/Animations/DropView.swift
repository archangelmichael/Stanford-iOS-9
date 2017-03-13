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

class DropView: NamedView, UIDynamicAnimatorDelegate {
    
    // MARK: - General parameters
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
    
    private lazy var animator : UIDynamicAnimator = {
        let animator = UIDynamicAnimator(referenceView: self)
        animator.delegate = self
        return animator
    }()
    
    func dynamicAnimatorDidPause(_ animator: UIDynamicAnimator) {
        self.removeFullRows()
    }
    
    private let dropBehavior = DropBehavior()
    
    // MARK: - Modes
    var dropMode : DropMode = DropMode.normal
    private var drops : [UIView] = []

    
    // MARK - ATTACHMENT
    private var lastDrop : UIView?
    
    private var attachment : UIAttachmentBehavior? {
        willSet {
            if attachment != nil {
                self.animator.removeBehavior(attachment!)
            }
        }
        didSet {
            if attachment != nil {
                self.animator.addBehavior(attachment!)
            }
        }
    }
    
    func grabDrop(recognizer: UIPanGestureRecognizer) {
        let gesturePoint = recognizer.location(in: self)
        switch recognizer.state {
        case .began: // Set attachment
            if let drop = self.lastDrop,
                drop.superview != nil {
                self.attachment = UIAttachmentBehavior(item: drop, attachedToAnchor: gesturePoint)
            }
            
            self.lastDrop = nil
        case .changed: // Change attachment anchor
            self.attachment?.anchorPoint = gesturePoint
        default:
            self.attachment = nil
        }
    }
    
    // MARK: - Center Collider
    private struct PathNames {
        static let Center = "Center"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Add center collider
        let centerPath = UIBezierPath(ovalIn: CGRect(center: bounds.mid, size: dropSize))
        self.dropBehavior.addBoundry(name: PathNames.Center,
                                      path: centerPath)
        self.besierPaths[PathNames.Center] = centerPath
    }
    
    // Add new drop
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
        
        if self.dropMode == .normal {
            self.lastDrop = drop
        }
    }
    
    // Remove drops with tapped drop color when tapped
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
    
    // Checks for full rows and removes them
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
