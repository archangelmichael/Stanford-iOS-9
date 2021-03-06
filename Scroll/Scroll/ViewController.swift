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
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    
    fileprivate var imageView : UIImageView = UIImageView()
    
    var imageUrl : URL? {
        didSet {
            self.image = nil
            if self.view.window != nil { // If view is on screen
                self.fetchImage()
            }
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
            self.loading?.stopAnimating()
        }
    }
    
    fileprivate func fetchImage() -> Void {
        if let url = self.imageUrl {
            self.loading?.startAnimating()
            DispatchQueue.global().async(execute: {
                do {
                    let data = try Data(contentsOf: url)
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            if url == self.imageUrl { // If it is still fetching the correct image
                                self.image = image
                            }
                            else {
                                self.loading?.stopAnimating()
                                // Ignore result
                            }
                        }
                    }
                }
                catch {
                }
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.vScroll.addSubview(imageView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.image == nil {
            self.fetchImage()
        }
    }

}

extension ViewController : UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
         return self.imageView
    }
}

