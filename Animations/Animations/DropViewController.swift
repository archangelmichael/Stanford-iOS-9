//
//  DropViewController.swift
//  Animations
//
//  Created by Radi on 3/13/17.
//  Copyright © 2017 Oryx. All rights reserved.
//

import UIKit

class DropViewController: UIViewController {
    
    let dropMode : DropMode = .hitIt
    
    @IBOutlet weak var gameView: DropView! {
        didSet {
            switch self.dropMode {
            case .hitIt:
                Timer.scheduledTimer(timeInterval: 0.1,
                                     target: self,
                                     selector: #selector(fillWithDrops),
                                     userInfo: nil,
                                     repeats: true)
                break
            case .normal:
                let tapGuesture = UITapGestureRecognizer(target: self,
                                                         action: #selector(addDrop(recognizer:)))
                self.gameView.addGestureRecognizer(tapGuesture)
            }
        }
    }
    
    func addDrop(recognizer: UITapGestureRecognizer) -> Void {
        if recognizer.state == .ended {
            self.gameView.addDrop()
        }
    }
    
    func fillWithDrops() -> Void {
        self.gameView.addDrop()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.gameView.dropMode = self.dropMode
        self.gameView.animating = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.gameView.animating = false
    }

}
