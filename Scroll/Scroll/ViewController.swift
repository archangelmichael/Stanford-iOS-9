//
//  ViewController.swift
//  Scroll
//
//  Created by Radi on 3/6/17.
//  Copyright © 2017 Oryx. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var vScroll: UIScrollView! {
        didSet {
            self.vScroll?.contentSize = self.imageView.frame.size 
        }
    }
    
    private var imageView : UIImageView = UIImageView()
    
    var imageUrl : URL? {
        didSet {
            self.image = nil
            self.fetchImage()
        }
    }
    
    private var image : UIImage? {
        get {
            return self.imageView.image
        }
        set {
            self.imageView.image = newValue
            self.imageView.sizeToFit()
            self.vScroll?.contentSize = self.imageView.frame.size
        }
    }
    
    private func fetchImage() -> Void {
        if let url = self.imageUrl {
            do {
                let data = try Data(contentsOf: url)
                if let image = UIImage(data: data) {
                    self.image = image
                }
            }
            catch {
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.vScroll.addSubview(imageView)
    }

}

