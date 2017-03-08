//
//  Extensions.swift
//  CustomAlertView
//
//  Created by Radi on 3/8/17.
//  Copyright © 2017 Oryx. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    /// Adds constraints to this `UIView` instances `superview` object to make sure this always has the same size as the superview.
    /// Please note that this has no effect if its `superview` is `nil` – add this `UIView` instance as a subview before calling this.
    func bindFrameToSuperviewBounds() {
        guard let superview = self.superview else {
            print("Error! `superview` was nil – call `addSubview(view: UIView)` before calling `bindFrameToSuperviewBounds()` to fix this.")
            return
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        superview.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|-8-[subview]-8-|",
                options: .directionLeadingToTrailing,
                metrics: nil,
                views: ["subview": self]
        ))
        
        superview.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-8-[subview]-8-|",
                options: .directionLeadingToTrailing,
                metrics: nil,
                views: ["subview": self]
        ))
    }
}

extension UIButton {
    static func getButtonWith(title: String?,
                              index: Int) -> UIButton {
        return self.getButtonWith(title: title,
                                  index: index,
                                  normalTextColor: UIColor.darkText,
                                  highlightedTextColor: UIColor.lightText,
                                  backgroundColor: UIColor.white)
    }
    
    static func getButtonWith(title: String?,
                              index: Int,
                              normalTextColor: UIColor?,
                              highlightedTextColor: UIColor?) -> UIButton {
        return self.getButtonWith(title: title,
                                  index: index,
                                  normalTextColor: normalTextColor,
                                  highlightedTextColor: highlightedTextColor,
                                  backgroundColor: UIColor.white)
    }
    
    static func getButtonWith(title: String?,
                              index: Int,
                              normalTextColor: UIColor?,
                              highlightedTextColor: UIColor?,
                              backgroundColor: UIColor?) -> UIButton {
        let btn = UIButton(frame: .zero)
        
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        btn.setTitle(title, for: .normal)
        btn.tag = index
        btn.setTitleColor(normalTextColor,
                          for: .normal)
        btn.setTitleColor(highlightedTextColor,
                          for: .highlighted)
        btn.backgroundColor = backgroundColor
        return btn
    }
}
