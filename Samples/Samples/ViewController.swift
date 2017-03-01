//
//  ViewController.swift
//  Samples
//
//  Created by Radi on 3/1/17.
//  Copyright © 2017 Oryx. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    required init?(coder aDecoder: NSCoder) {
        self.storedProp = 2.0
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let tuple = self.getTuple()
        print(tuple.int)
        print(self.getTuple().doub)
        
        var arr = [2, 5.51, 5, 7, 4]
        for element in arr {
            print(element)
        }
        
        // Arrays are copied by value
        var arrCopy = arr
        arrCopy.append(5.6)
        print(arr)
        print(arrCopy)
        
        let filteredArr = arr.filter({ $0 > 4})
        print(filteredArr)
        
        let convertedArr = arr.map({ String($0) })
        print(convertedArr)
        
        let sum = arr.reduce(0) { $0 - $1 }
        print(sum)
        
        let arr2 = [String]()
        print(arr2)
        
        // Dictionaries are copied by value
        var dict = [String:Double]()
        dict["key"] = 65.8
        var dictCopy = dict
        dictCopy["keyCopy"] = 78.67
        print(dict)
        print(dictCopy)
        for (key, value) in dict {
            print( "\(key) \(value)")
        }
        
        let range = arr[3...4]
        let range2 = arr[3..<4]
        print(range)
        print(range2)
        
        // Classes are copied by reference
        let project = Project(param: 56)
        let project2 = project
        project2.param = 89.0
        print(project.description())
        print(project2.description())
        
        
        self.naming(externalName: "Names in function")
        
        var doub = -5.6
        if doub.isZero {
            doub = Double.abs(-5.6)
        }
        
        self.storedProp = 45.7
        self.storedProp = 34.5
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    lazy var result = 0.0 // Not created until somebody asks for it
    
    var storedProp : Double {
        willSet {
            print("Will set \(newValue)")
        }
        didSet {
            print("Did set \(oldValue)")
        }
    }
    
    func getTuple() -> (doub : Double, str: String, int: Int) {
        return (3.4, "str", 5)
    }
    
    func naming(externalName internalName: String) -> Void {
        print(internalName)
    }
}

class Project {
    var param = 6.7
    init(param: Double) {
        self.param = param
    }
    
    func description() -> String {
        return "Project \(self.param)"
    }
}

// Function override in subclass
class SubViewController : ViewController {
    override func naming(externalName internalName: String) {
        print(internalName + " override")
    }
}

// Final function override in subclass
class SubSubViewController : SubViewController {
    final override func naming(externalName internalName: String) {
        print(internalName + " final override")
    }
}

