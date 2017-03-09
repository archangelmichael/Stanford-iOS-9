//
//  DropDownTableViewCell.swift
//  CustomFocus
//
//  Created by Radi on 3/9/17.
//  Copyright © 2017 Oryx. All rights reserved.
//

import UIKit

class DropDownTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
    class func estimatedHeight() -> CGFloat {
        return 40.0
    }
    
    class func nibName() -> String {
        return "DropDownTableViewCell"
    }
    
    class func reuseId() -> String {
        return "DropDownCell"
    }
}
