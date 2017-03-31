//
//  PageContentViewController.swift
//  FloatingButtonMenu
//
//  Created by Radi on 3/30/17.
//  Copyright © 2017 Oryx. All rights reserved.
//

import UIKit

class OnboardingPageContentViewController: UIViewController {

    @IBOutlet weak var ivBack: UIImageView!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    var pageIndex: Int?
    var titleText : String?
    
    var landscapeImage : String!
    var portraitImage : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rotate()
        self.lblTitle.text = self.titleText
        self.lblTitle.alpha = 0.1
        UIView.animate(
            withDuration: 1.0,
            animations: { () -> Void in
            self.lblTitle.alpha = 1.0
        })
        
    }
    
    fileprivate func rotate() {
        if UIDeviceOrientationIsLandscape(UIDevice.current.orientation) {
            self.ivBack.image = UIImage(named: self.landscapeImage)
        }
        
        if UIDeviceOrientationIsPortrait(UIDevice.current.orientation) {
            self.ivBack.image = UIImage(named: self.portraitImage)
        }
    }
    
    override func willTransition(to newCollection: UITraitCollection,
                                 with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection,
                             with: coordinator)
        self.rotate()
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
