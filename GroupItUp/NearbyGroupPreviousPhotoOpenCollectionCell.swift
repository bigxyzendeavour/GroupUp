//
//  NearbyGroupPreviousPhotoOpenCollectionCell.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-04-27.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit

class NearbyGroupPreviousPhotoOpenCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func configureCell(image: UIImage) {
        imageView.image = image
    }
    
}
