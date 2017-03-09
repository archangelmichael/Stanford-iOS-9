//
//  DropDownView.swift
//  CustomFocus
//
//  Created by Radi on 3/9/17.
//  Copyright © 2017 Oryx. All rights reserved.
//

import UIKit

protocol DropDownDelegate {
    func dropDownSelected(item: DropItem) -> Void
}

class DropDownView : UIView {
    var delegate : DropDownDelegate?
    
    @IBOutlet weak var tvItems: UITableView!
    @IBOutlet weak var vToolbar: UIToolbar!
    
    @IBOutlet weak var btnCancel: UIBarButtonItem!
    @IBOutlet weak var btnDone: UIBarButtonItem!
    
    var animationTime : Double = 0.5
    var parentOffset : CGFloat = 2.0
    var dropDownItems : [DropItem] = []
    var isDisplayed : Bool = false
    
    private func setup() {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 5.0
        self.clipsToBounds = true
        
        self.tvItems.dataSource = self
        self.tvItems.delegate = self
        
        let cellNib = UINib(nibName: DropDownTableViewCell.nibName(), bundle: nil)
        self.tvItems.register(cellNib, forCellReuseIdentifier: DropDownTableViewCell.reuseId())
        
        self.tvItems.separatorStyle = .none
        self.tvItems.rowHeight = UITableViewAutomaticDimension
        self.tvItems.estimatedRowHeight = DropDownTableViewCell.estimatedHeight()
        
        self.dropDownItems = []
        self.backgroundColor = UIColor.white
    }
    
    func setItems(items: [DropItem]) -> Void {
        self.dropDownItems = items
        self.tvItems.reloadData()
    }
    
    func showIn(parentView: UIView,
                delegate: DropDownDelegate?,
                fromView anchorView: UIView,
                withItems items: [DropItem]?,
                withHeight height: CGFloat = 120.0) -> Void {
        if self.isDisplayed {
            self.removeFromSuperview()
        }
        
        self.isDisplayed = !self.isDisplayed
        self.setup()
        
        self.delegate = delegate
        
        if items != nil {
            self.setItems(items: items!)
        }
        
        self.backgroundColor = anchorView.backgroundColor
        self.frame = CGRect(x: anchorView.frame.origin.x,
                            y: anchorView.frame.origin.y + anchorView.frame.size.height + self.parentOffset,
                            width: anchorView.frame.size.width,
                            height: height)
        self.alpha = 0.0
        
        parentView.addSubview(self)
        UIView.animate(withDuration: self.animationTime) {
            self.alpha = 1.0
        }
    }
    
    func hide() -> Void {
        UIView.animate(withDuration: animationTime,
                       animations:
            {
                self.alpha = 0.0
        }){ (complete) in
            self.removeFromSuperview()
        }
    }
    
    class func nibName() -> String {
        return "DropDownView"
    }
    
    class func instanceFromNib() -> DropDownView {
        return UINib(nibName: self.nibName(),
                     bundle: nil).instantiate(withOwner: nil,
                                              options: nil)[0] as! DropDownView
    }
}

extension DropDownView : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dropDownItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DropDownTableViewCell.reuseId(),
                                                 for: indexPath) as! DropDownTableViewCell
        let item = self.dropDownItems[indexPath.row]
        cell.lblTitle.text = item.title
        return cell
    }
}

extension DropDownView : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedItem = self.dropDownItems[indexPath.row]
        self.hide()
        if let observer = self.delegate {
            observer.dropDownSelected(item: selectedItem)
        }
    }
}
