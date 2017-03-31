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
    fileprivate var dismissHandler : (()-> Void)? = nil
    fileprivate var btnSkipPageTitle: String?
    fileprivate var btnSkipLastPageTitle: String?
    
    static fileprivate let onboardingStoryboardNameID : String = "Onboarding"
    fileprivate let onboardingParentID : String = "PageViewController"
    fileprivate let onboardingContentID : String = "PageContentViewController"
    
    fileprivate var pageViewController : UIPageViewController!
    
    @IBOutlet fileprivate weak var btnSkip: UIButton!
    @IBOutlet fileprivate weak var vBackground: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reset()
    }
    
    class func showOnboarding(from: UIViewController,
                               images: [String],
                               titles: [String?],
                               pageButtonTitle: String?,
                               lastPageButtonTitle: String?,
                               dismissCallback: (()-> Void)?) {
        guard images.count == titles.count else {
            print("Page images and titles don't match")
            return
        }
        
        let storyboard = UIStoryboard.init(name: onboardingStoryboardNameID, bundle: nil)
        let onboardingParent = storyboard.instantiateViewController(withIdentifier: "OnboardingParentVC")
        if let onboarding = onboardingParent as? OnboardingParentViewController {
            onboarding.images = images
            onboarding.pageTitles = titles
            onboarding.btnSkipPageTitle = pageButtonTitle
            onboarding.btnSkipLastPageTitle = lastPageButtonTitle
            onboarding.dismissHandler = dismissCallback
        }
        
        onboardingParent.modalPresentationStyle = .overFullScreen
        from.present(onboardingParent,
                     animated: true,
                     completion: nil)
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
        
        let pageContentViewController = self.viewController(atIndex: 0)
        self.pageViewController.setViewControllers([pageContentViewController!],
                                                   direction: UIPageViewControllerNavigationDirection.forward,
                                                   animated: true,
                                                   completion: nil)
        
        /* We are substracting 30 because we have a start again button whose height is 30*/
        self.pageViewController.view.frame = CGRect(x: 0,
                                                    y: 20,
                                                    width: self.view.frame.width,
                                                    height: self.view.frame.height - 20)
        
        self.addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
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
    
    @IBAction fileprivate func startOnboarding(_ sender: UIButton) {
        if let pageIndex = (self.pageViewController.viewControllers?.first as! OnboardingPageContentViewController).pageIndex {
            if pageIndex >= self.images.count - 1 { // Clicked next on last screen
                self.dismiss(animated: true,
                             completion: self.dismissHandler)
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
    
    fileprivate func changeSkipButton(title: String? = nil,
                                      forIndex index: Int) {
        if let btnTitle = title {
            self.btnSkip.setTitle(btnTitle, for: .normal)
        }
        else {
            let btnTitle = index >= self.images.count - 1 ? self.btnSkipLastPageTitle : self.btnSkipPageTitle
            self.btnSkip.setTitle(btnTitle, for: .normal)
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
        
        pageContentViewController.imageName = self.images[index]
        pageContentViewController.titleText = self.pageTitles[index]
        pageContentViewController.pageIndex = index
        return pageContentViewController
    }
    
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.pageTitles.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        if let pageIndex = (pageViewController.viewControllers?.first as! OnboardingPageContentViewController).pageIndex {
            self.changeSkipButton(forIndex: pageIndex)
            return pageIndex
        }
        
        self.changeSkipButton(title: "", forIndex: 0)
        return 0
    }
}
