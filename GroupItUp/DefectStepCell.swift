//
//  DefectStepCell.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-07-19.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit

protocol DefectStepCellDelegate {
    func updateStep(step: Step)
}

class DefectStepCell: UITableViewCell, UITextViewDelegate {
    
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var stepImage: UIImageView!
    @IBOutlet weak var stepDescriptionTextView: UITextView!

    var step: Step!
    var delegate: DefectStepCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        stepDescriptionTextView.delegate = self
    }

    func configureCell(step: Step) {
        stepLabel.text = "Step \(step.stepNum)"
        stepImage.image = step.stepImage
        stepDescriptionTextView.text = step.stepDescription
        stepDescriptionTextView.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if let delegate = self.delegate {
            step.stepDescription = stepDescriptionTextView.text
            delegate.updateStep(step: step)
        }
    }
}
