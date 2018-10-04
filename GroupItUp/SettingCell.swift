//
//  SettingCell.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-05-17.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit

class SettingCell: UITableViewCell {
    
    @IBOutlet weak var settingOptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(option: String) {
        settingOptionLabel.text = option
    }
}
