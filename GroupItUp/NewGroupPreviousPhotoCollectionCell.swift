//
//  NewGroupPreviousPhotoCollectionCell.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-05-13.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit

class NewGroupPreviousPhotoCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var previousPhotoImageView: UIImageView!
    
    func configureCell(image: UIImage) {
        previousPhotoImageView.image = image
    }
    
}
