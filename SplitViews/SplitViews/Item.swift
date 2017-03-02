//
//  Item.swift
//  SplitViews
//
//  Created by Radi on 3/2/17.
//  Copyright © 2017 Oryx. All rights reserved.
//

import Foundation

class Item {
    var id: Int
    var title: String
    var imageUrl: String
    
    init(id: Int, title: String, image: String) {
        self.id = id
        self.title = title
        self.imageUrl = image
    }
}
