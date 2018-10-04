//
//  NewGroupDescriptionCell.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-05-06.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit

protocol NewGroupDescriptionCellDelegate {
    func setGroupDescription(description: String)
    func getGroupDescription() -> String
    func setGroupTitle(title: String)
}

class NewGroupDescriptionCell: UITableViewCell, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var groupTitleTextField: UITextField!
    @IBOutlet weak var groupDescriptionTextView: UITextView!
    
    var delegate: NewGroupDescriptionCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        groupDescriptionTextView.delegate = self
        groupTitleTextField.delegate = self
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
//        let delegate = self.delegate
        
        if let groupDescription = groupDescriptionTextView.text, groupDescription != "" {
//            delegate?.setGroupDescription(description: groupDescription)
            newGroup.groupDetail.groupDetailDescription = groupDescription
            newGroupDetailForFirebase["Detail Description"] = groupDescription
        } else {
//            delegate?.setGroupDescription(description: "")
            newGroup.groupDetail.groupDetailDescription = ""
            newGroupDetailForFirebase["Detail Description"] = nil
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
//        let delegate = self.delegate
        if let groupTitle = groupTitleTextField.text, groupTitle != "" {
//            delegate?.setGroupTitle(title: groupTitle)
            newGroup.groupDetail.groupTitle = groupTitle
            newGroupDetailForFirebase["Title"] = groupTitle
        } else {
//            delegate?.setGroupTitle(title: "")
            newGroup.groupDetail.groupTitle = ""
            newGroupDetailForFirebase["Title"] = nil
        }
        
    }
    
//    func getGroupDescription() -> String {
//        if groupDescriptionTextView.text != "" {
//            return groupDescriptionTextView.text
//        }
//        return ""
//    }

}
