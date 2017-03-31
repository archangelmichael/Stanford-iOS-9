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
    var titleText : String!
    var imageName : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ivBack.image = UIImage(named: imageName)
        self.lblTitle.text = self.titleText
        self.lblTitle.alpha = 0.1
        UIView.animate(
            withDuration: 1.0,
            animations: { () -> Void in
            self.lblTitle.alpha = 1.0
        })
        
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
