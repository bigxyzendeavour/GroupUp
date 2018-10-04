//
//  NearbyGroupDetailCommentCell.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-04-17.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit

class NearbyGroupDetailCommentCell: UITableViewCell {

    @IBOutlet weak var userDisplayImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userCommentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        
    }
    
    func configureCell(comment: Comment, group: Group) {
        userDisplayImage.image = comment.userDisplayImage
        userCommentLabel.text = comment.comment
        
        if comment.userID == group.groupDetail.groupHost {
            self.usernameLabel.text = "\(comment.username)(Group host)"
        } else {
            self.usernameLabel.text = comment.username
        }
    }
}

