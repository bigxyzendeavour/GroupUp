//
//  MyFollowUserCell.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-07-13.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit

class MyFollowUserCell: UITableViewCell {

    @IBOutlet weak var hostDisplayImage: UIImageView!
    @IBOutlet weak var hostNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(host: Host) {
        hostDisplayImage.heightCircleView()
        hostDisplayImage.image = host.userDisplayImage
        hostNameLabel.text = host.username
    }
}
