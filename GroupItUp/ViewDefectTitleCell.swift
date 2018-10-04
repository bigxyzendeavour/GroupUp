//
//  ViewDefectTitleCell.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-07-25.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit

class ViewDefectTitleCell: UITableViewCell {
    
    @IBOutlet weak var defectTitleLabel: UILabel!
    @IBOutlet weak var defectStatusLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(defect: Defect) {
        defectTitleLabel.text = defect.defectTitle
        defectStatusLabel.text = defect.status
    }
}
