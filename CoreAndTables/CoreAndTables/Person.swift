//
//  Target.swift
//  CoreAndTables
//
//  Created by Radi on 3/9/17.
//  Copyright © 2017 Oryx. All rights reserved.
//
import UIKit

enum Gender {
    case Male
    case Female
}

class Person {
    var name: String
    var gender : Gender
    var age : Int
    var isMarried: Bool = false
    var avatar: UIImage?
    
    init(name: String, age: Int, gender: Gender) {
        self.name = name
        self.age = age
        self.gender = gender
        switch self.gender {
        case .Male:
            self.avatar = UIImage(named: "man")
            break
        case .Female:
            self.avatar = UIImage(named: "woman")
            break
        }
        self.isMarried = false
    }
    
    func marry() -> Void {
        self.isMarried = true
    }
}
