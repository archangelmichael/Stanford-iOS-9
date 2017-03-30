//
//  ViewController.swift
//  FloatingButtonMenu
//
//  Created by Radi on 3/27/17.
//  Copyright © 2017 Oryx. All rights reserved.
//

import UIKit
import KCFloatingActionButton

class ViewController: UIViewController {

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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupSlideInButtons()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupSlideInButtons() -> Void {
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
    
    func setupSlideInButton(btn: KCFloatingActionButtonItem,
                            color: UIColor,
                            title: String?,
                            icon: String?,
                            handler: ((KCFloatingActionButtonItem) -> Void)?) {
        self.setSlideBtnInfo(btn: btn, title: title, icon: icon)
        btn.buttonColor = color
        btn.titleColor = color // text color
        btn.handler = handler
    }
    
    func setSlideBtnInfo(btn: KCFloatingActionButtonItem,
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
}

