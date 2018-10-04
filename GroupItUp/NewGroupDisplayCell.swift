//
//  NewGroupDisplayCell.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-05-06.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit

class NewGroupDisplayCell: UITableViewCell {
    
    @IBOutlet weak var groupDisplayImageView: UIImageView!

    var group: Group!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configureCell(groupDisplayImage: UIImage) {
        groupDisplayImageView.image = groupDisplayImage
    }
    
    
    
}
