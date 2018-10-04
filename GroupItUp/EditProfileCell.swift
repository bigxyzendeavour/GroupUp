//
//  EditProfileCell.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-05-30.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit

class EditProfileCell: UITableViewCell {
    
    @IBOutlet weak var optionLabel: UILabel!
    @IBOutlet weak var currentValueLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(editOption: String) {
        optionLabel.text = editOption
        
        var currentValue = ""
        switch editOption {
        case "Username":
            currentValue = currentUser.username
            break
        case "Gender":
            currentValue = currentUser.gender
            break
        case "Region":
            currentValue = currentUser.region
        default:
            break
        }
        currentValueLabel.text = currentValue
    }
}
