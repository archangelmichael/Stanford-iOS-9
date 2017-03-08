//
//  ViewController.swift
//  CustomFocus
//
//  Created by Radi on 3/8/17.
//  Copyright © 2017 Oryx. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var vContent: UIView!
    @IBOutlet weak var vScroll: UIScrollView!
    
    @IBOutlet var textFields: [UITextField]!
    
    var keyboardHeight : CGFloat = 260.0
    let toolbarHeight : CGFloat = 40.0
    let keyboardTopMargin : CGFloat = 10.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardShown),
                                               name:NSNotification.Name.UIKeyboardWillShow,
                                               object: nil);
        
        for tf in textFields {
            tf.delegate = self
        }
    }
    
    func keyboardShown(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        self.keyboardHeight = keyboardFrame.size.height
    }
}

extension ViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        let tfYPos = textField.frame.origin.y
        let tfHeight = textField.frame.size.height
        
        let keyboard : CGFloat = self.keyboardHeight + self.toolbarHeight + self.keyboardTopMargin
        let screenHeight : CGFloat = self.view.frame.size.height
        
        let yOffsetPos = tfYPos + tfHeight - screenHeight + keyboard
        
        let currentOffset = self.vScroll.contentOffset
        self.vScroll.setContentOffset(CGPoint(x:currentOffset.x,
                                              y:yOffsetPos),
                                      animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.vScroll.setContentOffset(.zero,
                                      animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var currentTfFound = false
        for tf in self.textFields {
            if tf == textField {
                currentTfFound = true
            }
            else if currentTfFound {
                tf.becomeFirstResponder()
                return true
            }
        }
        
        textField.resignFirstResponder()
        return true
    }
}

