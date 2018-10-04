//
//  FeedbackTableCell.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-06-14.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit

class FeedbackTableCell: UITableViewCell {
    
    @IBOutlet weak var feedbackTitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func configureCell(title: String) {
        feedbackTitleLabel.text = title
    }
}
