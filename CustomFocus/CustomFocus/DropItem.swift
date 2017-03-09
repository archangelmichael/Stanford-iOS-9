//
//  DropItem.swift
//  CustomFocus
//
//  Created by Radi on 3/9/17.
//  Copyright © 2017 Oryx. All rights reserved.
//

import Foundation

class DropItem {
    var title: String
    var value: Int
    
    init(title: String, value: Int) {
        self.title = title
        self.value = value
    }
    
    class func getDropItems(range: (min:Int, max: Int), count: Int) -> [DropItem] {
        var items : [DropItem] = []
        
        guard count > 0 else {
            return items
        }
        
        for _ in 0..<count {
            let value = self.randomIntFrom(start: range.min, to: range.max)
            let item = DropItem(title: "Item \(value)", value: value)
            items.append(item)
        }
        
        return items
    }
    
    private class func randomIntFrom(start: Int, to end: Int) -> Int {
        var a = start
        var b = end
        // swap to prevent negative integer crashes
        if a > b {
            swap(&a, &b)
        }
        
        return Int(arc4random_uniform(UInt32(b - a + 1))) + a
    }
}
