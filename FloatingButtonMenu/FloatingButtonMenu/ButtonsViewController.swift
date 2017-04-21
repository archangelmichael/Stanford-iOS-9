//
//  ButtonsViewController.swift
//  FloatingButtonMenu
//
//  Created by Radi on 4/21/17.
//  Copyright © 2017 Oryx. All rights reserved.
//

import UIKit

class ButtonsViewController: UIViewController {

    @IBOutlet weak var btnBlue: UIButton!
    @IBOutlet weak var btnRed: UIButton!
    
    var documentInteractionController : UIDocumentInteractionController?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let redTitle = self.getAttrStrWith(text: "RED")
        self.btnRed.setAttributedTitle(redTitle,
                                       for: .normal)
        self.btnRed.setAttributedTitle(redTitle,
                                       for: .highlighted)
        self.btnRed.setAttributedTitle(redTitle,
                                       for: .selected)
        
        
        let blueTitle = self.getAttrStrWith(text: "BLUE")
        self.btnBlue.setAttributedTitle(blueTitle,
                                        for: .normal)
        self.btnBlue.setAttributedTitle(blueTitle,
                                        for: .highlighted)
        self.btnBlue.setAttributedTitle(blueTitle,
                                        for: .selected)
        
//        self.btnRed.setTitleColor(UIColor.white,
//                                  for: .normal)
//        self.btnRed.setTitleColor(UIColor.black,
//                                  for: .highlighted)
//        self.btnRed.setTitleColor(UIColor.white,
//                                  for: .selected)
        self.btnRed.setBackgroundImage(UIImage(color: UIColor.lightGray),
                                       for: .normal)
        self.btnRed.setBackgroundImage(UIImage(color: UIColor.red),
                                       for: .selected)
        
        self.btnBlue.setBackgroundImage(UIImage(color: UIColor.lightGray),
                                        for: .normal)
        self.btnBlue.setBackgroundImage(UIImage(color: UIColor.blue),
                                        for: .selected)

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getAttrStrWith(text: String) -> NSAttributedString {
        let attrs = [NSForegroundColorAttributeName : UIColor.white,
                     NSBackgroundColorAttributeName : UIColor.clear]
        let attrString = NSAttributedString(string: text,
                                            attributes: attrs)
        return attrString
    }
    
    @IBAction func onBlue(_ sender: UIButton) {
        self.btnRed.isSelected = false;
        
        if self.btnBlue.isSelected {
            self.btnBlue.isSelected = false;
        }
        else {
            self.btnBlue.isSelected = true;
        }
        
    }

    @IBAction func onRed(_ sender: UIButton) {
        self.btnBlue.isSelected = false;
        
        if self.btnRed.isSelected {
            self.btnRed.isSelected = false;
        }
        else {
            self.btnRed.isSelected = true;
        }
    }
    
    func sharePDF() {
        if let pdfUrl = Bundle.main.url(forResource: "sample",
                                        withExtension: "pdf") {
            self.documentInteractionController = UIDocumentInteractionController(url: pdfUrl)
            self.documentInteractionController?.delegate = self
            self.documentInteractionController?.presentOpenInMenu(from: self.btnRed.frame,
                                                                  in: self.view,
                                                                  animated: true)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIViewController : UIDocumentInteractionControllerDelegate {
    
}

public extension UIImage {
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}
