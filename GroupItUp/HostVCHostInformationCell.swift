//
//  HostVCHostInformationCell.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-07-11.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit

class HostVCHostInformationCell: UITableViewCell {
    
    @IBOutlet weak var hostDisplayImageView: UIImageView!
    @IBOutlet weak var hostNameLabel: UILabel!
    @IBOutlet weak var hostFollowedLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    
        
    }

    func configureCell(host: Host) {
        if host.userID == currentUser.userID {
            followButton.isEnabled = false
            followButton.backgroundColor = UIColor.lightGray
        }
        hostDisplayImageView.heightCircleView()
        hostDisplayImageView.image = host.userDisplayImage
        hostNameLabel.text = host.username
        hostFollowedLabel.text = "\(host.followHosts.count)"
    }
}
