//
//  AlertTableViewCell.swift
//  CustomAlertView
//
//  Created by Radi on 3/6/17.
//  Copyright © 2017 Oryx. All rights reserved.
//

import UIKit

class AlertTableViewCell: UITableViewCell {

    @IBOutlet weak var lblAlert: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static func reuseId() -> String  {
        return "AlertCell"
    }
    
    static func nibNam() -> String {
        return "AlertTableViewCell"
    }
}
