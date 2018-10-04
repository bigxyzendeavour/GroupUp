//
//  BugReportImageCell.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-07-19.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit

class BugReportImageCell: UITableViewCell {
    
    @IBOutlet weak var bugImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(bugImage: UIImage) {
        bugImageView.image = bugImage
    }
}
