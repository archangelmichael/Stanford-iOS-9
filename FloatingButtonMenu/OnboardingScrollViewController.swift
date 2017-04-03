//
//  OnboardingScrollViewController.swift
//  FloatingButtonMenu
//
//  Created by Radi on 4/3/17.
//  Copyright © 2017 Oryx. All rights reserved.
//

import UIKit

class OnboardingScrollViewController: UIViewController {

    @IBOutlet weak var vBackground: UIView!
    
    @IBOutlet weak var vScroll: UIScrollView!
    
    @IBOutlet weak var vPageControl: UIPageControl!
    
    @IBOutlet weak var btnClose: UIButton!
    
    static fileprivate let onboardingStoryboardNameID : String = "Onboarding"
    static fileprivate let onboardingVCId = "OnboardingScrollVC"
    
    fileprivate var closeText: String? = "Let's go"
    fileprivate var closePosition: UIControlContentHorizontalAlignment = .center
    fileprivate var dismissHandler: (() -> Void)?
    fileprivate var onboardingPortraitImages : [String] = []
    fileprivate var onboardingLandscapeImages : [String] = []
    fileprivate var backgroundColor : UIColor?
    fileprivate var currentPage = 0
    
    
    class func showOnboarding(
        from: UIViewController,
        portraitImages: [String],
        landscapeImages: [String]? = nil,
        closeText: String? = "",
        closePosition : UIControlContentHorizontalAlignment = .right,
        backgroundColor: UIColor? = nil,
        dismissCallback: (()-> Void)? = nil) {
            guard portraitImages.count >= 0 else {
                print("Invalid images count")
                
                if dismissCallback != nil {
                    dismissCallback!()
                }
                
                return
            }
        
            let storyboard = UIStoryboard.init(name: onboardingStoryboardNameID , bundle: nil)
            let onboardingParent = storyboard.instantiateViewController(withIdentifier: onboardingVCId)
            if let onboarding = onboardingParent as? OnboardingScrollViewController {
                onboarding.onboardingPortraitImages = portraitImages
                
                if landscapeImages == nil || landscapeImages?.count != portraitImages.count {
                    onboarding.onboardingLandscapeImages = portraitImages
                }
                else {
                    onboarding.onboardingLandscapeImages = landscapeImages!
                }
                
                onboarding.backgroundColor = backgroundColor
                onboarding.closePosition = closePosition
                onboarding.dismissHandler = dismissCallback
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
        
        self.btnClose.contentHorizontalAlignment = self.closePosition
        self.vBackground.backgroundColor = self.backgroundColor
        
        self.currentPage = 0
        self.vPageControl.isUserInteractionEnabled = false
        self.vPageControl.numberOfPages = self.onboardingPortraitImages.count
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.vScroll.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.reloadOnboarding(animated: false)
    }
    
    func reloadOnboarding(animated: Bool) {
        if animated {
            self.setScrollView(visible: false,
                               completion: { (complete) in
                                let scrollViewSize = self.getSizeForOrientation()
                                let images = self.getImagesForScreenOrientation()
                                self.setScreens(screens: images,
                                                size: scrollViewSize,
                                                page: 0)
                                self.setScrollView(visible: true,
                                                   completion: nil)
            })
        }
        else {
            let scrollViewSize = self.getSizeForOrientation()
            let images = self.getImagesForScreenOrientation()
            self.setScreens(screens: images,
                            size: scrollViewSize,
                            page: 0)
            self.setScrollView(visible: true,
                               completion: nil)
        }
    }
    
    func setScrollView(visible: Bool,
                       completion: ((Bool) -> Void)?) {
        UIView.animate(
            withDuration: visible ? 0.5 : 0.2,
            animations:
            {
                self.vScroll.alpha = visible ? 1.0: 0.0
        },
            completion: completion)
    }
    
    func getSizeForOrientation() -> CGSize {
        let width = self.vScroll.frame.size.width
        let height = self.vScroll.frame.size.height
        
        
//        switch UIDevice.current.userInterfaceIdiom {
//        case .phone:
//            return CGSize(width: width,
//                          height: height)
//        case .pad:
//            break
//        case .unspecified:
//            break
//        default:
//            break
//        }
        
        return CGSize(width: width,
                      height: height)
        
//        switch UIDevice.current.orientation {
//        case .portrait, .portraitUpsideDown:
//            return CGSize(width: width,
//                          height: height)
//        case .landscapeLeft, .landscapeRight:
//            return CGSize(width: width,
//                          height: height)
//        default:
//            return CGSize(width: width,
//                          height: height)
//        }
    }
    
    func getImagesForScreenOrientation() -> [String] {
//        switch UIDevice.current.userInterfaceIdiom {
//        case .phone:
//            return onboardingPortraitImages
//        case .pad:
//            break
//        case .unspecified:
//            break
//        default:
//            break
//        }
        
        switch UIDevice.current.orientation {
        case .portrait, .portraitUpsideDown:
            return onboardingPortraitImages
        case .landscapeLeft, .landscapeRight:
            return onboardingLandscapeImages
        default:
            return onboardingPortraitImages
        }
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
    
    @IBAction func onClose(_ sender: UIButton) {
        self.closeOnboarding()
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
        
        // Switch between close button and page controller depending on current page index
        self.switchControlesFor(page: page)
        
        self.currentPage = page
        self.vPageControl.currentPage = page
        self.scrollTo(index: page)
    }
    
    func switchControlesFor(page: Int) {
        let lastPageIndex = self.onboardingPortraitImages.count - 1
        self.vPageControl.isHidden = lastPageIndex == page
        self.btnClose.isHidden = lastPageIndex != page
    }
    
    func scrollTo(index: Int) {
        self.vScroll.setContentOffset(CGPoint(x: self.vScroll.frame.size.width * CGFloat(index), y: 0),
                                      animated: false)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isPortrait { // Portrait
            print("Portrait")
            
            
        }
        else if UIDevice.current.orientation.isLandscape { // Landscape
            print("Landscape")
        }
        
        self.reloadOnboarding(animated: true)
        
//        let scrollViewSize = size
//        let images = self.getImagesForScreenOrientation()
//        self.setScreens(screens: images,
//                        size: scrollViewSize,
//                        page: 0)
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
        let pageWidth = self.vScroll.frame.size.width
        let fractionOfPage : CGFloat = self.vScroll.contentOffset.x / pageWidth
        let page = lround(Double(fractionOfPage))
        if page != self.currentPage {
            self.setCurrentPage(index: page)
            print("Page Changed : \(page)")
        }
    }
}
