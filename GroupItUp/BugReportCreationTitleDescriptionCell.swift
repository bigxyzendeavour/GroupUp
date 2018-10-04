//
//  BugReportCreationTitleDescriptionCell.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-07-19.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit

protocol BugReportCreationTitleDescriptionCellDelegate {
    func updateBugTitle(bugTitle: String)
    func updateBugDescription(bugDescription: String)
}

class BugReportCreationTitleDescriptionCell: UITableViewCell, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var bugTitleTextField: UITextField!
    @IBOutlet weak var bugDescriptionTextView: UITextView!
    
    var delegate: BugReportCreationTitleDescriptionCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bugTitleTextField.delegate = self
        bugDescriptionTextView.delegate = self
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let delegate = self.delegate {
            delegate.updateBugTitle(bugTitle: bugTitleTextField.text!)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if let delegate = self.delegate {
            delegate.updateBugDescription(bugDescription: bugDescriptionTextView.text)
        }
    }
}
