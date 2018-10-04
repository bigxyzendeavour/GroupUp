//
//  FeedbackDetailCommentCell.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-07-08.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit

class FeedbackDetailCommentCell: UITableViewCell {
    
    @IBOutlet weak var userDisplayImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userCommentLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(comment: Comment) {
        userDisplayImage.heightCircleView()
        userDisplayImage.image = comment.userDisplayImage
        usernameLabel.text = comment.username
        userCommentLabel.text = comment.comment
    }
}
