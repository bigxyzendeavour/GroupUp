//
//  userDataCollectionCell.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-07-18.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit

class userDataCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var userDataNameLabel: UILabel!
    @IBOutlet weak var userDataNumberLabel: UILabel!
    
    func configureCell(name: String, number: Int) {
        userDataNameLabel.text = name
        userDataNumberLabel.text = "\(number)"
    }
}
