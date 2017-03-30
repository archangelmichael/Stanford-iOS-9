//
//  ViewController.swift
//  FloatingButtonMenu
//
//  Created by Radi on 3/27/17.
//  Copyright © 2017 Oryx. All rights reserved.
//

import UIKit
import KCFloatingActionButton

import paper_onboarding
import Onboard

enum Options : Int {
    case Paper = 0
    case Onboard = 1
    case AllCount
    
    func getTitle() -> String? {
        switch self {
        case .Paper:
            return "Paper Onboarding"
        case .Onboard:
            return "Onboard"
        default:
            return "None"
        }
    }
}

class ViewController: UIViewController {

    fileprivate let cellReuseId = "OptionCell"
    fileprivate let onboardingImages = ["screen0", "screen1", "screen2"]
    
    @IBOutlet weak var tvOptions: UITableView! {
        didSet {
            self.tvOptions.delegate = self
            self.tvOptions.dataSource = self
        }
    }
    
    @IBOutlet weak var btnFloat: KCFloatingActionButton! {
        didSet {
            self.btnFloat.autoCloseOnTap = true
            self.btnFloat.openAnimationType = .fade
            self.btnFloat.rotationDegrees = CGFloat(180/2*M_PI)
            
            self.btnFloat.buttonImage = UIImage(named:"menu-off")
            
            self.btnFloat.plusColor = UIColor.white // btn tint color
            self.btnFloat.buttonColor = UIColor.blue // btn background color
            self.btnFloat.overlayColor = UIColor.black.withAlphaComponent(0.5)
        }
    }
    
    private var okItem : KCFloatingActionButtonItem = KCFloatingActionButtonItem()
    private var lockItem : KCFloatingActionButtonItem = KCFloatingActionButtonItem()
    private var okActive : Bool = true
    private var lockActive : Bool = true
    
    
    fileprivate var paperDismisser : UITapGestureRecognizer?
    fileprivate var paperOnboarding : PaperOnboarding = PaperOnboarding(itemsCount: 3) {
        didSet {
            self.paperOnboarding.delegate = self
            self.paperOnboarding.dataSource = self
            self.paperOnboarding.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    fileprivate var onboardingVC : OnboardingViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSlideInButtons()
        
        self.paperOnboarding = PaperOnboarding(itemsCount: self.onboardingImages.count)
        
        self.paperDismisser = UITapGestureRecognizer(target: self,
                                                     action: #selector(self.hidePaperOnboarding))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func setupSlideInButtons() -> Void {
        self.okActive = true
        self.setupSlideInButton(btn: self.okItem,
                                color: UIColor.green,
                                title: "CANCEL",
                                icon: "cancel") { [weak self] (item : KCFloatingActionButtonItem) in
                                    DispatchQueue.main.async {
                                        if let weakSelf = self {
                                            if weakSelf.okActive {
                                                weakSelf.setSlideBtnInfo(btn: weakSelf.okItem,
                                                                         title: "OK",
                                                                         icon: "ok")
                                            }
                                            else {
                                                weakSelf.setSlideBtnInfo(btn: weakSelf.okItem,
                                                                         title: "CANCEL",
                                                                         icon: "cancel")
                                            }
                                            
                                            weakSelf.okActive = !weakSelf.okActive
                                        }
                                    }
        }
        
        self.btnFloat.addItem(item: self.okItem)
        
        self.lockActive = true
        self.setupSlideInButton(btn: self.lockItem,
                                color: UIColor.red,
                                title: "UNLOCK",
                                icon: "unlock") { [weak self] (item : KCFloatingActionButtonItem) in
                                    DispatchQueue.main.async {
                                        if let weakSelf = self {
                                            if weakSelf.lockActive {
                                                weakSelf.setSlideBtnInfo(btn: weakSelf.lockItem,
                                                                         title: "LOCK",
                                                                         icon: "lock")
                                            }
                                            else {
                                                weakSelf.setSlideBtnInfo(btn: weakSelf.lockItem,
                                                                         title: "UNLOCK",
                                                                         icon: "unlock")
                                            }
                                            
                                            weakSelf.lockActive = !weakSelf.lockActive
                                        }
                                    }
        }
        
        self.btnFloat.addItem(item: self.lockItem)
        
        self.btnFloat.itemSize = 50.0
        self.btnFloat.itemSpace = 20.0
    }
    
    fileprivate func setupSlideInButton(btn: KCFloatingActionButtonItem,
                                        color: UIColor,
                                        title: String?,
                                icon: String?,
                                handler: ((KCFloatingActionButtonItem) -> Void)?) {
        self.setSlideBtnInfo(btn: btn, title: title, icon: icon)
        btn.buttonColor = color
        btn.titleColor = color // text color
        btn.handler = handler
    }
    
    fileprivate func setSlideBtnInfo(btn: KCFloatingActionButtonItem,
                                     title: String?,
                                     icon: String?) {
        btn.title = title
        if let iconTitle = icon {
            btn.icon = UIImage(named: iconTitle)
        }
        else {
            btn.icon = nil
        }
        
    }
    
    fileprivate func showOnboarding(option: Options?) {
        guard let type = option else {
            return;
        }
        
        switch type {
        case .Paper:
            // Show paper onboarding
                self.view.addSubview(self.paperOnboarding)
                
                // add constraints
                for attribute: NSLayoutAttribute in [.left, .right, .top, .bottom] {
                    let constraint = NSLayoutConstraint(item: self.paperOnboarding,
                                                        attribute: attribute,
                                                        relatedBy: .equal,
                                                        toItem: view,
                                                        attribute: attribute,
                                                        multiplier: 1,
                                                        constant: 0)
                    self.view.addConstraint(constraint)

                }
                
                self.paperOnboarding.addGestureRecognizer(self.paperDismisser!)
            
            break;
        case .Onboard:
            weak var weakSelf = self
            
            var onboardingPages : [OnboardingContentViewController] = []
            for (index, imageName) in self.onboardingImages.enumerated() {
                
                let vc = self.getOnboardingPage(
                    title: "",
                    body: "",
                    image: imageName,
                    buttonTitle: index < self.onboardingImages.count - 1 ? "" : "",
                    buttonHandler: nil
//                    index == self.onboardingImages.count - 1 ?
//                        { weakSelf?.onboardingVC?.dismiss(animated: true, completion: nil) } :
//                        { weakSelf?.onboardingVC?.moveNextPage() }
                )
                
                if index < self.onboardingImages.count - 1 {
                    vc.viewDidAppearBlock = {
                        weakSelf?.onboardingVC?.skipButton.setTitle("Next", for: .normal)
                    }
                }
                else {
                    vc.viewDidAppearBlock = {
                        weakSelf?.onboardingVC?.skipButton.setTitle("Enter", for: .normal)
                    }
                }
                
                onboardingPages.append(vc)
            }
            
            self.onboardingVC = OnboardingViewController(backgroundImage: nil,
                                                         contents: onboardingPages)
            
            // Setup onboarding background
            self.onboardingVC?.backgroundImage = nil
            self.onboardingVC?.shouldBlurBackground = true;
        
            
            
            self.onboardingVC?.swipingEnabled = true
            
            // Setup skip button
            self.onboardingVC?.allowSkipping = true
            self.onboardingVC?.fadeSkipButtonOnLastPage = false
            
            self.onboardingVC?.skipButton.setTitleColor(UIColor.white, for: .normal)
            self.onboardingVC?.skipButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24.0)
            self.onboardingVC?.skipButton.layer.cornerRadius = 10.0
            self.onboardingVC?.skipButton.clipsToBounds = true
            
            // Setup page controll
            self.onboardingVC?.shouldFadeTransitions = true;
            self.onboardingVC?.pageControl.currentPageIndicatorTintColor = UIColor.white
            self.onboardingVC?.pageControl.pageIndicatorTintColor = UIColor.lightGray
            self.onboardingVC?.fadePageControlOnLastPage = true
            
            self.onboardingVC?.skipHandler =
                { () -> Void in
                    if let page = weakSelf?.onboardingVC?.pageControl.currentPage {
                        if page == self.onboardingImages.count - 1 {
                            weakSelf?.onboardingVC?.dismiss(animated: true, completion: nil)
                        }
                        else {
                            weakSelf?.onboardingVC?.moveNextPage()
                        }
                    }
            }
            
            self.onboardingVC?.modalPresentationStyle = .overCurrentContext
            self.present(self.onboardingVC!, animated: true, completion: {
                
            })
            
            break
        default:
            print("Invalid type : \(type)");
            return;
        }
    }
    
    func getOnboardingPage(title: String,
                           body: String,
                           image: String,
                           buttonTitle: String,
                           buttonHandler: (() -> Void)?) -> OnboardingContentViewController {
        let page = OnboardingContentViewController(title: title,
                                                   body: body,
                                                   image: UIImage(named: image),
                                                   buttonText: buttonTitle,
                                                   action: buttonHandler)
        
        page.topPadding = 0;
        page.bottomPadding = 10;
        
//        page.actionButton.setTitleColor(UIColor.white, for: .normal)
//        page.actionButton.backgroundColor = UIColor.purple
//        page.actionButton.layer.cornerRadius = 10.0
//        page.actionButton.clipsToBounds = true
        
        // Setup image view
        page.iconWidth = self.view.bounds.width
        page.iconHeight = self.view.bounds.height - 40.0
        page.iconImageView.contentMode = .scaleToFill
        
//        page.iconImageView.translatesAutoresizingMaskIntoConstraints = false
//        for attribute: NSLayoutAttribute in [.left, .right, .top, .bottom] {
//            let constraint = NSLayoutConstraint(item: page.iconImageView,
//                                                attribute: attribute,
//                                                relatedBy: .equal,
//                                                toItem: page.view,
//                                                attribute: attribute,
//                                                multiplier: 1,
//                                                constant: 0)
//            page.view.addConstraint(constraint)
//        }
        
        return page
    }
    
    func hidePaperOnboarding(dismisser: UITapGestureRecognizer) {
        let pageIndex = self.paperOnboarding.currentIndex
        if pageIndex == self.onboardingImages.count - 1 {
            self.paperOnboarding.removeGestureRecognizer(self.paperDismisser!)
            self.paperOnboarding.removeFromSuperview()
            self.paperOnboarding.currentIndex(0, animated: false)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
    }
}

extension ViewController: PaperOnboardingDataSource, PaperOnboardingDelegate {
    func onboardingItemsCount() -> Int {
        return self.onboardingImages.count
    }
    
    func onboardingItemAtIndex(_ index: Int) -> OnboardingItemInfo {
        let item = self.onboardingImages[index]
        let color = self.getRandomColor()
        
        return (
            imageName: item,
            title: "", //item,
            description: "", // item,
            iconName: item,
            color: color,
            titleColor: UIColor.white,
            descriptionColor: UIColor.white,
            titleFont: UIFont.boldSystemFont(ofSize: 30.0),
            descriptionFont: UIFont.systemFont(ofSize: 20.0)
        )
    }
    
    fileprivate func getRandomColor() -> UIColor {
        let randomRed:CGFloat = CGFloat(drand48())
        let randomGreen:CGFloat = CGFloat(drand48())
        let randomBlue:CGFloat = CGFloat(drand48())
        return UIColor(red: randomRed,
                       green: randomGreen,
                       blue: randomBlue,
                       alpha: 1.0)
    }
    
    func onboardingDidTransitonToIndex(_ index: Int) {
    }
    
    func onboardingWillTransitonToIndex(_ index: Int) {
    }
    
    func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index: Int) {
        //item.titleLabel?.backgroundColor = self.getRandomColor()
        //item.descriptionLabel?.backgroundColor = self.getRandomColor()
        item.imageView?.animationDuration = 3
        item.imageView?.animationRepeatCount = 100
        item.imageView?.animationImages  = [
            UIImage( named: self.onboardingImages[0])!,
            UIImage( named: self.onboardingImages[1])!,
            UIImage( named: self.onboardingImages[2])!
        ]
        
        item.imageView?.startAnimating()
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: self.cellReuseId)
        let row = indexPath.row
        cell?.textLabel?.text = Options(rawValue: row)?.getTitle()
        return cell!
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return Options.AllCount.rawValue
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        self.showOnboarding(option: Options(rawValue: row))
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

