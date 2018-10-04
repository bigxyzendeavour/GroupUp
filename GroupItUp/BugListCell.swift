//
//  BugListCell.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-07-22.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit

class BugListCell: UITableViewCell {
    
    @IBOutlet weak var bugTitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(bug: Defect) {
        bugTitleLabel.text = bug.defectTitle
    }
}
