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
    
    @IBOutlet weak var btnDrop: UIButton!
    
    @IBOutlet var textFields: [UITextField]!
    
    var keyboardHeight : CGFloat = 260.0
    let toolbarHeight : CGFloat = 40.0
    let keyboardTopMargin : CGFloat = 10.0
    
    var dropRows : [DropItem] {
        get {
            return DropItem.getDropItems(range: (3, 100), count: 7)
        }
    }
    
    let dropDown = DropDownView.instanceFromNib()
    
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
    
    // MARK: - CUSTOM DROPDOWN
    @IBAction func onCustomDropdown(_ sender: UIButton) -> Void {
        self.dropDown.showIn(parentView: self.vContent,
                             delegate: self,
                             fromView: sender,
                             withItems: self.dropRows)
    }
    
    // MARK: - ACTION SHEET DROPDOWN
    @IBAction func onDrop(_ sender: UIButton) {
        let alert = UIAlertController(title: "My Alert",
                                      message: "This is an action sheet.",
                                      preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                        style: .cancel)
        {
            (alert: UIAlertAction!) -> Void in
            NSLog("CANCEL")
        }
        
        for index in (1...20) {
            alert.addAction(self.getActionWith(title: "Act \(index)"))
        }
        
        alert.addAction(cancelAction)
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func getActionWith(title: String?) -> UIAlertAction {
        return UIAlertAction(title: title,
                             style: .default)
        {
            (alert: UIAlertAction!) -> Void in
            print("\(title)")
        }
    }
}

extension ViewController : DropDownDelegate {
    func dropDownSelected(item: DropItem) {
        print("Item selected : \(item.value)")
    }
}

extension ViewController : UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        print("ROW SELECTED \(self.dropRows[row].title)")
    }
}

extension ViewController : UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.dropRows.count
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        return self.dropRows[row].title
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

