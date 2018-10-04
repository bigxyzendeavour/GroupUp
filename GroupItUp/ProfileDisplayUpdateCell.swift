//
//  ProfileDisplayUpdateCell.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-05-30.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit

class ProfileDisplayUpdateCell: UITableViewCell {
    
    @IBOutlet weak var profileDisplayImageView: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(image: UIImage) {
        profileDisplayImageView.heightCircleView()
        profileDisplayImageView.image = image
    }

}
