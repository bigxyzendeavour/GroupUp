//
//  ViewDefectDisplayCell.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-07-25.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit
import Firebase

class ViewDefectDisplayCell: UITableViewCell {
    
    @IBOutlet weak var defectImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(defect: Defect) {
        let url = defect.defectImageURL
        Storage.storage().reference(forURL: url).getData(maxSize: 1024 * 1024) { (data, error) in
            if error != nil {
                print("\(error?.localizedDescription)")
            } else {
                let image = UIImage(data: data!)
                self.defectImage.image = image
            }
        }
        
    }
}
