//
//  Brain.swift
//  Calculator
//
//  Created by Radi on 2/28/17.
//  Copyright © 2017 Oryx. All rights reserved.
//

import Foundation

enum Operation : String {
    case Add = "+",
    Remove = "-",
    Multiply = "*",
    Divide = "/",
    Percent = "%"
}

class Brain {
    private var resultStored: Bool = false
    private var result : Double = 0
    var nextOperation : Operation?
    
    func clear() -> Void {
        self.result = 0
        self.nextOperation = nil
    }
    
    func saveResult(newInput : Double, operation: String) -> Void {
        if !resultStored {
            self.result = newInput
            resultStored = true
        }
        
        self.nextOperation = Operation.init(rawValue: operation)
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
    
    
    enum Action {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    var operations : Dictionary<String, Action> = [
        "e" : Action.Constant(M_E),
        "cos" : Action.UnaryOperation(cos),
        "x" : Action.BinaryOperation({ $0 * $1})
    ];
    
    func performOperation(symbol: String) -> Void {
        var result = 0.0
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value): result = value
                break
            case .UnaryOperation(let function) :
                result = function(result)
                break
            case .BinaryOperation(let function) :
                result = function(4.5, 6.6)
                break
            case .Equals:
                // Execute pending operation
                break
            }
        }
    }
    
}
