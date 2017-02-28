//
//  ViewController.swift
//  Calculator
//
//  Created by Radi on 2/28/17.
//  Copyright © 2017 Oryx. All rights reserved.
//

import UIKit

enum Operation : String {
    case Add = "+",
    Remove = "-",
    Multiply = "*",
    Divide = "/",
    Percent = "%"
}

class CalculatorVC: UIViewController {

    @IBOutlet weak var lblResult: UILabel!
    @IBOutlet weak var btnNumber: UIButton!
    
    @IBOutlet var btnsDigits: [UIButton]!
    @IBOutlet var btnsOperation: [UIButton]!
    
    private var brain : Brain = Brain()
    
    private var changeOperationsEnabled = true
    private var digitOperationsEnabled = true
    
    private var currentStrValue : String {
        get {
            return self.lblResult.text!
        }
        set {
            self.lblResult.text = newValue
        }
    }
    
    private var currentValue : Double {
        get {
            return Double(self.currentStrValue)!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearCalculation()
        self.setOperationsStatus(digitsActive: true,
                                 changeActive: true)
        
        self.lblResult.layer.cornerRadius = 10.0
        self.lblResult.clipsToBounds = true
        
        // Set buttons appearance
        for button in self.btnsDigits {
            button.tintColor = UIColor.white
            
            button.roundCorners(radius: 10.0)
            button.setBackgroundColor(color: UIColor.lightGray, forState: .normal)
            button.setBackgroundColor(color: UIColor.red, forState: .highlighted)
        }
        
        for button in self.btnsOperation {
            button.tintColor = UIColor.white
            
            button.roundCorners(radius: 10.0)
            button.setBackgroundColor(color: UIColor.darkGray, forState: .normal)
            button.setBackgroundColor(color: UIColor.red, forState: .highlighted)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func clearCalculation() -> Void {
        self.brain.clear()
        self.clearCurrentInput()
    }
    
    private func clearCurrentInput() -> Void {
        self.currentStrValue = "0"
        self.setOperationsStatus(digitsActive: true,
                                 changeActive: true)
    }
    
    private func setOperationsStatus(digitsActive: Bool?, changeActive: Bool?) -> Void {
        if digitsActive != nil {
            self.digitOperationsEnabled = digitsActive!
        }
        
        if changeActive != nil {
            self.changeOperationsEnabled = changeActive!
        }
    }

    @IBAction private func onDigit(_ sender: UIButton) {
        guard self.digitOperationsEnabled else {
            print("Digits disabled")
            return
        }
        
        self.setOperationsStatus(digitsActive: true, changeActive: true)
        if let digit = sender.currentTitle {
            if self.currentValue == 0 && self.currentStrValue.lowercased().range(of:".") == nil {
                self.currentStrValue = digit
            }
            else {
                self.currentStrValue = self.currentStrValue + digit
            }
        }
    }
    
    @IBAction private func onDot(_ sender: UIButton) {
        if self.currentStrValue.lowercased().range(of:".") == nil {
            self.currentStrValue = self.currentStrValue + "."
            self.setOperationsStatus(digitsActive: true, changeActive: false)
        }
    }
    
    @IBAction private func onOperation(_ sender: UIButton) {
        guard self.changeOperationsEnabled else {
            print("Operations disabled")
            return
        }
        
        if let operation = sender.currentTitle {
            switch operation {
            case "C":
                self.clearCurrentInput()
                brain.nextOperation = nil
                break
            case "CE":
                self.clearCalculation()
                brain.nextOperation = nil
                break
            case "=":
                let result = brain.getCalculatedResult(newInput: self.currentValue)
                self.currentStrValue = String(result)
                break
            case "+",
                 "-",
                 "*",
                 "/",
                 "%":
                brain.saveResult(newInput: self.currentValue)
                self.clearCurrentInput()
                brain.nextOperation = Operation.init(rawValue: operation)
                break
            default:
                self.clearCalculation()
                break
            }
        }
    }
}

extension UIButton {
    func setBackgroundColor(color: UIColor, forState: UIControlState) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        context.setFillColor(color.cgColor)
        context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.setBackgroundImage(colorImage, for: forState)
    }
    
    func roundCorners(radius: CGFloat) -> Void {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
}

