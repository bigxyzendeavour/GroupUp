//
//  AppPreviewCell.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-09-16.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit

class AppPreviewCell: UICollectionViewCell {
    
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var previewDescriptionLabel: UILabel!
    
    func configureCell(image: UIImage, desc: String) {
        previewImage.image = image
        previewDescriptionLabel.text = desc
    }
}
