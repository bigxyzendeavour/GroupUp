//
//  ViewDefectDescriptionCell.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-07-25.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit

class ViewDefectDescriptionCell: UITableViewCell {

    @IBOutlet weak var defectDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(defect: Defect) {
        defectDescriptionLabel.text = defect.defectDescription
    }

}
