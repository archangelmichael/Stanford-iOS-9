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
            self.vScroll?.delegate = self
            self.vScroll?.maximumZoomScale = 2.0
            self.vScroll?.minimumZoomScale = 0.5
        }
    }
    
    fileprivate var imageView : UIImageView = UIImageView()
    
    var imageUrl : URL? {
        didSet {
            self.image = nil
            self.fetchImage()
        }
    }
    
    fileprivate var image : UIImage? {
        get {
            return self.imageView.image
        }
        set {
            self.imageView.image = newValue
            self.imageView.sizeToFit()
            self.vScroll?.contentSize = self.imageView.frame.size
        }
    }
    
    fileprivate func fetchImage() -> Void {
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

extension ViewController : UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
         return self.imageView
    }
}

