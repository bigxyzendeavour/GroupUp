//
//  ViewDefectStepCell.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-07-25.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit
import Firebase

class ViewDefectStepCell: UITableViewCell {
    
    @IBOutlet weak var stepNumberLabel: UILabel!
    @IBOutlet weak var stepImage: UIImageView!
    @IBOutlet weak var stepContentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(step: Step) {
        stepNumberLabel.text = "Step \(step.stepNum)"
        stepContentLabel.text = step.stepDescription
        let stepImageURL = step.stepImgUrl
        Storage.storage().reference(forURL: stepImageURL).getData(maxSize: 1024 * 1024) { (data, error) in
            if error != nil {
                print("\(error?.localizedDescription)")
            } else {
                let image = UIImage(data: data!)
                self.stepImage.image = image
            }
        }
    }

}
