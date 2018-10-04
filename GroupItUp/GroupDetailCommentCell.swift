//
//  GroupDetailCommentCell.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-04-21.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit

class GroupDetailCommentCell: UITableViewCell {

    @IBOutlet weak var userDisplayImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userCommentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

    func configureCell(comment: Comment) {
        userDisplayImage.heightCircleView()
        userDisplayImage.image = comment.userDisplayImage
        
        usernameLabel.text = comment.username
        userCommentLabel.text = comment.comment
    }
}
