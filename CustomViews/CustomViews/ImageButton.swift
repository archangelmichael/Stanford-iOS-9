//
//  ImageButton.swift
//  CustomViews
//
//  Created by Radi on 3/2/17.
//  Copyright © 2017 Oryx. All rights reserved.
//

import UIKit

class ImageButton: UIButton {
    
    var ivIcon : UIImageView!
    var iconSize : CGFloat = 40.0
    var offset : CGFloat = 5.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func setup() -> Void {
        let lblFrame = CGRect(
            x: offset,
            y: offset,
            width: self.frame.size.width - iconSize - 3 * offset,
            height: self.frame.size.height - 2 * offset
        )
        
        let ivFrame = CGRect(
            x: lblFrame.width + 2 * offset,
            y: offset,
            width: iconSize,
            height: lblFrame.height
        )
        
        self.titleLabel?.frame = lblFrame
        self.titleLabel?.text = "PUSHER"
        
        let btnImage = UIImage(named: "red")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.ivIcon = UIImageView(frame: ivFrame)
        self.ivIcon.contentMode = .scaleAspectFit
        self.ivIcon.image = btnImage
        self.addSubview(self.ivIcon)
        
        self.setTitleColor(UIColor.red, for: UIControlState.normal)
        self.setTitleColor(UIColor.yellow, for: UIControlState.highlighted)
        
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
