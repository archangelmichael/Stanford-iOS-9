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

class PersonClass {
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
    
    class func getSome() -> [PersonClass] {
        return [
            PersonClass(name: "George",
                        age: 23,
                        gender: Gender.Male),
            PersonClass(name: "Natasha",
                        age: 33,
                        gender: Gender.Female),
            PersonClass(name: "Simon",
                        age: 45,
                        gender: Gender.Male),
            PersonClass(name: "Marrie",
                        age: 27,
                        gender: Gender.Female),
            PersonClass(name: "Hulk",
                        age: 46,
                        gender: Gender.Male),
            PersonClass(name: "Cristie",
                        age: 18,
                        gender: Gender.Female)
        ]
    }
}
