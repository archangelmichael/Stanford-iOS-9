//
//  OnboardingViewController.swift
//  FloatingButtonMenu
//
//  Created by Radi on 3/30/17.
//  Copyright © 2017 Oryx. All rights reserved.
//

import UIKit

class OnboardingParentViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    fileprivate var pageTitles : [String?] = []
    fileprivate var images : [String] = []
    fileprivate var landscapeImages : [String] = []
    
    fileprivate var dismissHandler : (()-> Void)? = nil
    
    fileprivate var contentOffset : CGFloat = 20.0
    
    static fileprivate let onboardingStoryboardNameID : String = "Onboarding"
    fileprivate let onboardingParentID : String = "PageViewController"
    fileprivate let onboardingContentID : String = "PageContentViewController"
    
    fileprivate var pageViewController : UIPageViewController!

    fileprivate var pageBtnTag: Int = 0
    fileprivate var skipBtnTitle: String?
    fileprivate var pageBtnTitle: String?
    fileprivate var lastPageBtnTitle: String?
    fileprivate let closeBtnTag : Int = 999
    fileprivate let defaultCloseBtnTitle : String = "Let's go"
    
    @IBOutlet fileprivate weak var btnSkip: UIButton!
    @IBOutlet fileprivate weak var btnPage: UIButton!
    @IBOutlet fileprivate weak var vBackground: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reset()
    }
    
    class func showOnboarding(from: UIViewController,
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
        
        let storyboard = UIStoryboard.init(name: onboardingStoryboardNameID, bundle: nil)
        let onboardingParent = storyboard.instantiateViewController(withIdentifier: "OnboardingParentVC")
        if let onboarding = onboardingParent as? OnboardingParentViewController {
            onboarding.pageTitles = titles
            onboarding.images = portraitImages
            onboarding.landscapeImages = portraitImages
            if let landscapes = landscapeImages, landscapeImages?.count == portraitImages.count {
                onboarding.landscapeImages = landscapes
            }
            
            onboarding.skipBtnTitle = skipBtnTitle
            
            if closeBtnTitle != nil { // Set page button as close button
                onboarding.setPageButton(tag: onboarding.closeBtnTag,
                                         title: closeBtnTitle,
                                         lastTitle: nil)
            }
            else if lastPageBtnTitle == nil || lastPageBtnTitle == "" {
                onboarding.setPageButton(tag: onboarding.closeBtnTag,
                                         title: onboarding.defaultCloseBtnTitle,
                                         lastTitle: nil)
            }
            else {
                onboarding.setPageButton(tag: 0,
                                         title: pageBtnTitle,
                                         lastTitle: lastPageBtnTitle)
            }
            
            onboarding.setContent(offset: offset ? 20.0: 0)
            onboarding.dismissHandler = dismissCallback
        }
        
        onboardingParent.modalPresentationStyle = .overFullScreen
        from.present(onboardingParent,
                     animated: true,
                     completion: nil)
    }
    
    fileprivate func setPageButton(tag: Int, title: String?, lastTitle: String?) {
        self.pageBtnTag = tag
        self.pageBtnTitle = title
        
        if lastTitle == nil || lastTitle == "" {
            self.lastPageBtnTitle = title
        }
        else {
            self.lastPageBtnTitle = lastTitle
        }
    }
    
    fileprivate func setContent(offset: CGFloat) {
        self.contentOffset = offset
    }
    
    @IBAction func onPage(_ sender: UIButton) {
        if sender.tag == closeBtnTag {
            self.closeOnboarding()
            return;
        }
        
        if let pageIndex = (self.pageViewController.viewControllers?.first as! OnboardingPageContentViewController).pageIndex {
            if pageIndex >= self.images.count - 1 { // Clicked next on last screen
                self.closeOnboarding()
            }
            else {
                let pageContentViewController = self.viewController(atIndex: pageIndex + 1)
                self.pageViewController.setViewControllers([pageContentViewController!],
                                                           direction: UIPageViewControllerNavigationDirection.forward,
                                                           animated: true,
                                                           completion: nil)
            }
        }
    }
    
    @IBAction func onSkip(_ sender: UIButton) {
        self.closeOnboarding()
    }
    
    func closeOnboarding() {
        self.dismiss(animated: true,
                     completion: self.dismissHandler)
    }
    
    @IBAction fileprivate func swipeLeft(sender: AnyObject) {
        print("Swipe left")
    }
    
    @IBAction func swiped(sender: AnyObject) {
        self.pageViewController.view.removeFromSuperview()
        self.pageViewController.removeFromParentViewController()
        reset()
    }
    
    fileprivate func reset() {
        /* Getting the page View controller */
        self.pageViewController = self.storyboard?.instantiateViewController(withIdentifier: self.onboardingParentID) as! UIPageViewController
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        
        let pageContentViewController = self.viewController(atIndex: 0)
        self.pageViewController.setViewControllers([pageContentViewController!],
                                                   direction: UIPageViewControllerNavigationDirection.forward,
                                                   animated: true,
                                                   completion: nil)
        
        self.btnSkip.setBtn(title: self.skipBtnTitle)
        self.btnPage.tag = self.pageBtnTag
        self.changePageBtnTitle(forIndex: 0)
        
        /* We are substracting 30 because we have a start again button whose height is 30*/
        self.pageViewController.view.frame = CGRect(x: 0,
                                                    y: self.contentOffset,
                                                    width: self.view.frame.width,
                                                    height: self.view.frame.height - self.contentOffset)
        
        self.addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
        self.view.bringSubview(toFront: self.btnPage)
        self.view.bringSubview(toFront: self.btnSkip)
        self.pageViewController.didMove(toParentViewController: self)
    }
    
    fileprivate func start() {
        let pageContentViewController = self.viewController(atIndex: 0)
        self.pageViewController.setViewControllers([pageContentViewController!],
                                                   direction: UIPageViewControllerNavigationDirection.forward,
                                                   animated: true,
                                                   completion: nil)
    }
    
//    @IBAction fileprivate func startOnboarding(_ sender: UIButton) {
//        if let pageIndex = (self.pageViewController.viewControllers?.first as! OnboardingPageContentViewController).pageIndex {
//            if pageIndex >= self.images.count - 1 { // Clicked next on last screen
//                self.dismiss(animated: true,
//                             completion: self.dismissHandler)
//            }
//            else {
//                let pageContentViewController = self.viewController(atIndex: pageIndex + 1)
//                self.pageViewController.setViewControllers([pageContentViewController!],
//                                                           direction: UIPageViewControllerNavigationDirection.forward,
//                                                           animated: true,
//                                                           completion: nil)
//            }
//        }
//    }
    
    fileprivate func changePageBtnTitle(forIndex index: Int) {
        if self.btnPage.tag == self.closeBtnTag {
            self.btnPage.setBtn(title: self.pageBtnTitle)
        }
        else{
            let btnTitle = index >= self.images.count - 1 ? self.lastPageBtnTitle : self.pageBtnTitle
            self.btnPage.setBtn(title: btnTitle)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! OnboardingPageContentViewController).pageIndex!
        index = index + 1
        if(index >= self.images.count){
            return nil
        }
        
        return self.viewController(atIndex: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! OnboardingPageContentViewController).pageIndex!
        if(index <= 0){
            return nil
        }
        
        index = index - 1
        return self.viewController(atIndex: index)
    }
    
    fileprivate func viewController(atIndex index : Int) -> UIViewController? {
        if (self.pageTitles.count == 0) || (index >= self.pageTitles.count) {
            return nil
        }
        
        let pageContentViewController = self.storyboard?.instantiateViewController(withIdentifier: self.onboardingContentID) as! OnboardingPageContentViewController
        
        pageContentViewController.portraitImage = self.images[index]
        pageContentViewController.landscapeImage = self.landscapeImages[index]
        pageContentViewController.titleText = self.pageTitles[index]
        pageContentViewController.pageIndex = index
        return pageContentViewController
    }
    
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.pageTitles.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        if let currentPage = pageViewController.viewControllers?.first as? OnboardingPageContentViewController {
            if let page = currentPage.pageIndex {
                self.changePageBtnTitle(forIndex: page)
                return page
            }
        }
        
        self.changePageBtnTitle(forIndex: 0)
        return 0
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            willTransitionTo pendingViewControllers: [UIViewController]) {
        if let nextVC = pendingViewControllers.first as? OnboardingPageContentViewController {
            if let page = nextVC.pageIndex {
                self.changePageBtnTitle(forIndex: page)
                return;
            }
        }
        
        self.changePageBtnTitle(forIndex: 0)
    }
}

extension UIButton {
    func setBtn(title: String?) {
        self.setTitle(title, for: .normal)
        self.isHidden = title == nil || title == ""
    }
}
