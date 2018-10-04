//
//  FeedbackDescriptionCell.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-07-14.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit

class FeedbackDescriptionCell: UITableViewCell {
    
    @IBOutlet weak var feedbackTitleLabel: UILabel!
    @IBOutlet weak var feedbackDescriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func configureCell(feedback: Feedback) {
        feedbackTitleLabel.text = feedback.feedbackTitle
        feedbackDescriptionLabel.text = feedback.feedbackContent
    }

}
