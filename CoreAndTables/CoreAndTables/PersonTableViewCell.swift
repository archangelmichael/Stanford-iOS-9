//
//  TaskTableViewCell.swift
//  CoreAndTables
//
//  Created by Radi on 3/10/17.
//  Copyright © 2017 Oryx. All rights reserved.
//

import UIKit

class PersonTableViewCell: UITableViewCell {

    @IBOutlet weak var ivAvatar: UIImageView!
    
    @IBOutlet weak var ivMarried: UIImageView!
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var btnDone: UIButton!

    var person : PersonClass? {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI() -> Void {
        if let candidate = person {
            self.ivMarried?.isHidden = !candidate.isMarried
            self.ivAvatar?.image = candidate.avatar
            self.lblName?.text = candidate.name
            self.btnDone?.isHidden = candidate.isMarried
        }
    }
}
