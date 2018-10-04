//
//  UserSavedGroupCollectionCell.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-05-02.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit

class UserSavedGroupCollectionCell: UICollectionViewCell {
    
    
    
    @IBOutlet weak var userCategoryContainerView: UIView!
    @IBOutlet weak var savedCategoryImageView: UIImageView!
    @IBOutlet weak var savedCategoryLabel: UILabel!
    
    func configureCell(category: String) {
//        userCategoryContainerView.heightCircleView(radius: 15)
        savedCategoryImageView.heightCircleView()
//        savedCategoryLabel.heightCircleView(radius: 15)
        savedCategoryLabel.text = category
        savedCategoryImageView.image = UIImage(named: category)
    }
}
