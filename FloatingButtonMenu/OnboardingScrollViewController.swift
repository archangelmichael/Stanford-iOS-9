//
//  OnboardingScrollViewController.swift
//  FloatingButtonMenu
//
//  Created by Radi on 4/3/17.
//  Copyright © 2017 Oryx. All rights reserved.
//

import UIKit

class OnboardingScrollViewController: UIViewController {

    @IBOutlet weak var vScroll: UIScrollView!
    
    @IBOutlet weak var vPageControl: UIPageControl!
    
    static fileprivate let onboardingStoryboardNameID : String = "Onboarding"
    static fileprivate let onboardingVCId = "OnboardingScrollVC"
    
    fileprivate var dismissHandler: (() -> Void)?
    fileprivate var onboardingPortraitImages = ["LP1", "LP2", "LP3"]
    fileprivate var onboardingLandscapeImages = ["LP1", "LP2", "LP3"]
    fileprivate var currentPage = 0
    
    
    class func showOnboarding(
        from: UIViewController,
        portraitImages: [String],
        landscapeImages: [String]? = nil,
        titles: [String?],
        pageBtnTitle: String? = nil,
        lastPageBtnTitle: String? = nil,
        skipBtnTitle: String? = nil,
        closeBtnTitle: String? = nil,
        offset: Bool = true,
        dismissCallback: (()-> Void)? = nil) {
            guard portraitImages.count == titles.count else {
                print("Page images and titles don't match")
                return
            }
            
            let storyboard = UIStoryboard.init(name: onboardingStoryboardNameID , bundle: nil)
            let onboardingParent = storyboard.instantiateViewController(withIdentifier: onboardingVCId)
            if let onboarding = onboardingParent as? OnboardingScrollViewController {
                
            }
            
            onboardingParent.modalPresentationStyle = .overFullScreen
            from.present(onboardingParent,
                         animated: true,
                         completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.vScroll.delegate = self
        self.vScroll.isPagingEnabled = true
        self.vScroll.alwaysBounceVertical = false
        
        self.vPageControl.isUserInteractionEnabled = false
        
        let scrollViewSize = CGSize(width: self.vScroll.frame.size.width,
                                    height: self.vScroll.frame.size.height)
        self.setScreens(screens: self.onboardingPortraitImages,
                        size: scrollViewSize,
                        page: 0)
        
//        self.currentPage = 0
//        
//        for (index, imageName) in onboardingPortraitImages.enumerated() {
//            let xPos = CGFloat(index) * vScroll.frame.size.width
//            let imageView = UIImageView(frame: CGRect(x: xPos,
//                                                      y: 0,
//                                                      width: self.vScroll.frame.size.width,
//                                                      height: self.vScroll.frame.size.height))
//            imageView.contentMode = .scaleAspectFit
//            imageView.image = UIImage(named: imageName)
//            self.vScroll.addSubview(imageView)
//        }
//        
//        self.vScroll.contentSize = CGSize(width: self.vScroll.frame.size.width * CGFloat(self.onboardingPortraitImages.count),
//                                          height: self.vScroll.frame.size.height)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setScreens(screens: [String],
                    size: CGSize,
                    page: Int?) {
        // Remove all subviews
        for view in self.vScroll.subviews {
            view.removeFromSuperview()
        }
        
        // Add image views for each screen
        for (index, imageName) in screens.enumerated() {
            let xPos = CGFloat(index) * size.width
            let imageView = UIImageView(frame: CGRect(x: xPos,
                                                      y: 0,
                                                      width: size.width,
                                                      height: size.height))
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage(named: imageName)
            self.vScroll.addSubview(imageView)
        }
        
        self.vScroll.contentSize = CGSize(width: size.width * CGFloat(screens.count),
                                          height: size.height)
        
        if let pageIndex = page {
            self.setCurrentPage(index: pageIndex)
        }
        else {
            self.setCurrentPage(index: 0)
        }
    }
    
    func closeOnboarding() {
        self.dismiss(animated: true,
                     completion: self.dismissHandler)
    }

    func setCurrentPage(index : Int) {
        var page = index
        
        if page < 0 {
            page = 0
        }
        
        if page > self.onboardingPortraitImages.count {
            page = self.onboardingPortraitImages.count - 1
        }
        
        self.currentPage = page
        self.vPageControl.currentPage = page
        self.scrollTo(index: page)
    }
    
    func scrollTo(index: Int) {
        self.vScroll.setContentOffset(CGPoint(x: self.vScroll.frame.size.width * CGFloat(index), y: 0),
                                      animated: false)
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

extension OnboardingScrollViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // var currentPage = 0
        let pageWidth = self.vScroll.frame.size.width
        let fractionOfPage : CGFloat = self.vScroll.contentOffset.x / pageWidth
        let page = lround(Double(fractionOfPage))
        if page != self.currentPage {
            self.setCurrentPage(index: page)
            print("Page Changed : \(page)")
        }
    }
}
