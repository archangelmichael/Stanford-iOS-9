 //
//  DropBehavior.swift
//  Animations
//
//  Created by Radi on 3/13/17.
//  Copyright © 2017 Oryx. All rights reserved.
//

import UIKit

class DropBehavior: UIDynamicBehavior {

    private let gravity = UIGravityBehavior()
    private let collider : UICollisionBehavior = {
        let collider = UICollisionBehavior()
        collider.translatesReferenceBoundsIntoBoundary = true
        return collider
    }()
    
    private let itemBehavior : UIDynamicItemBehavior = {
        let dib = UIDynamicItemBehavior()
        dib.allowsRotation = false
        dib.elasticity = 0.3
        return dib
    }()
    
    override init() {
        super.init()
        
        self.addChildBehavior(self.gravity)
        self.addChildBehavior(self.collider)
        self.addChildBehavior(self.itemBehavior)
    }
    
    func addItem(item: UIDynamicItem) -> Void {
        self.gravity.addItem(item)
        self.collider.addItem(item)
        self.itemBehavior.addItem(item)
    }
    
    func removeItem(item: UIDynamicItem) -> Void {
        self.gravity.removeItem(item)
        self.collider.removeItem(item)
        self.itemBehavior.removeItem(item)
    }
}
