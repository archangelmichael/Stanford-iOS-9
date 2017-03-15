//
//  DotAnnotation.swift
//  Maps
//
//  Created by Radi on 3/15/17.
//  Copyright © 2017 Oryx. All rights reserved.
//

import UIKit
import MapKit

struct DotFrame {
    static let DefaultFrame : CGRect = CGRect(x: 0,
                                              y: 0,
                                              width: 30.0,
                                              height: 30.0)
}

class DotAnnotation: MKAnnotationView {
    private var imageView : UIImageView = UIImageView(frame: DotFrame.DefaultFrame)
    private var lblCount : UILabel = UILabel(frame: DotFrame.DefaultFrame) {
        didSet {
            self.lblCount.textColor = UIColor.white
            self.lblCount.backgroundColor = UIColor.cyan
            self.lblCount.numberOfLines = 0
            self.lblCount.minimumScaleFactor = 0.5
            self.lblCount.contentMode = .center
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if self.imageView.superview == nil {
            self.addSubview(self.imageView)
            self.addSubview(self.lblCount)
        }
    }

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        if self.imageView.superview == nil {
            self.addSubview(self.imageView)
            self.addSubview(self.lblCount)
        }
        
        if let dot = annotation as? Dot {
            self.setImage(image: dot.image)
            self.setCount(count: dot.tags.count)
        }
    }
    
    func setSize(size: CGSize) -> Void {
        self.frame = CGRect(origin: self.frame.origin,
                            size: size)
        self.imageView.frame = self.frame
        self.lblCount.frame = self.frame
    }
    
    func setCount(count: Int) -> Void {
        self.lblCount.textColor = UIColor.white
        self.lblCount.numberOfLines = 0
        self.lblCount.minimumScaleFactor = 0.5
        self.lblCount.contentMode = .center
        self.lblCount.textAlignment = .center
        self.lblCount.text = count > 0 ? "\(count)" : ""
    }
    
    func setImage(image: UIImage?) -> Void {
        self.imageView.contentMode = .scaleAspectFit
        self.imageView.image = image
    }
}
