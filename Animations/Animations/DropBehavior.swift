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
    
    override init() {
        super.init()
        
        self.addChildBehavior(self.gravity)
        self.addChildBehavior(self.collider)
    }
    
    func addItem(item: UIDynamicItem) -> Void {
        self.gravity.addItem(item)
        self.collider.addItem(item)
    }
    
    func removeItem(item: UIDynamicItem) -> Void {
        self.gravity.removeItem(item)
        self.collider.removeItem(item)
    }
}
