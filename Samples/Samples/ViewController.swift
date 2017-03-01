//
//  ViewController.swift
//  Samples
//
//  Created by Radi on 3/1/17.
//  Copyright © 2017 Oryx. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let tuple = self.getTuple()
        print(tuple.int)
        print(self.getTuple().doub)
        
        let arr = [2,5,5,7,4]
        let range = arr[3...4]
        let range2 = arr[3..<4]
    
        self.naming(externalName: "Names in function")
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getTuple() -> (doub : Double, str: String, int: Int) {
        return (3.4, "str", 5)
    }
    
    func naming(externalName internalName: String) -> Void {
        print(internalName)
    }

}

