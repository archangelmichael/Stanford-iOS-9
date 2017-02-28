//
//  Brain.swift
//  Calculator
//
//  Created by Radi on 2/28/17.
//  Copyright © 2017 Oryx. All rights reserved.
//

import Foundation


class Brain {
    private var resultStored: Bool = false
    private var result : Double = 0
    var nextOperation : Operation?
    
    func clear() -> Void {
        self.result = 0
        self.nextOperation = nil
    }
    
    func saveResult(newInput : Double) -> Void {
        if !resultStored {
            self.result = newInput
            resultStored = true
        }
    }
    
    func getCalculatedResult(newInput : Double) -> Double {
        if let operation = self.nextOperation {
            switch operation {
            case .Add:
                self.result = self.result + newInput
                break
            case .Remove:
                self.result = self.result - newInput
                break
            case .Multiply:
                self.result = self.result * newInput
                break
            case .Divide:
                self.result = self.result / newInput
                break
            default:
                // Calculate percentage
                self.result = self.result * 100 / newInput
                break
            }
        }
        else {
            self.result = newInput
        }
        
        return self.result
    }
}
