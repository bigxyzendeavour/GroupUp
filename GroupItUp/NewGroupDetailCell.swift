//
//  NewGroupDetailCell.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-05-06.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit

protocol NewGroupDetailCellDelegate {
    func setGroupDetail(detail: Dictionary<String, Any>)
    
}

class NewGroupDetailCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var maxTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var contactTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!

    var delegate: NewGroupDetailCellDelegate?
    var datePicker: UIDatePicker!
    var pickerView: UIPickerView!
    let categoryArray = ["", "Sport", "Entertainment", "Travel", "Food", "Study"]
    static var detail = [String: Any]()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        maxTextField.delegate = self
        timeTextField.delegate = self
        contactTextField.delegate = self
        phoneTextField.delegate = self
        emailTextField.delegate = self
        categoryTextField.delegate = self
        
    }
    
//    func configureCell(detail: Dictionary<String, Any>) {
//        if detail.keys.contains("Max Attending Members") {
//            maxTextField.text = "\(detail["Max Attending Members"]!)"
//            }
//        if detail.keys.contains("Time") {
//            timeTextField.text = "\(detail["Time"]!)"
//        }
//        if detail.keys.contains("Contact") {
//            contactTextField.text = "\(detail["Contact"])"
//        }
//        if detail.keys.contains("Phone") {
//            phoneTextField.text = "\(detail["Phone"])"
//        }
//        if detail.keys.contains("Email") {
//            emailTextField.text = "\(detail["Email"])"
//        }
//        if detail.keys.contains("Category") {
//            categoryTextField.text = "\(detail["Category"])"
//        }
//    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let delegate = self.delegate {
            let tag = textField.tag
            switch tag {
            case 0:
                if let max = Int(maxTextField.text!) {
                    NewGroupDetailCell.detail["Max Attending Members"] = max
                } else {
                    NewGroupDetailCell.detail["Max Attending Members"] = nil
                }
                break
            case 1:
                let selectedDate = datePicker.date
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                let date = dateFormatter.string(from: selectedDate as Date)
                timeTextField.text = date
                NewGroupDetailCell.detail["Time"] = date
                break
            case 2:
                let contactPerson = contactTextField.text
                if contactPerson != "" {
                    NewGroupDetailCell.detail["Contact"] = contactPerson
                } else {
                    NewGroupDetailCell.detail["Contact"] = nil
                }
                break
            case 3:
                if let phoneNumber = phoneTextField.text {
                    if phoneNumber != "" {
                        NewGroupDetailCell.detail["Phone"] = phoneNumber
                    } else {
                        NewGroupDetailCell.detail["Phone"] = nil
                    }
                }
                break
            case 4:
                let emailAddress = emailTextField.text
                if emailAddress != "" {
                    NewGroupDetailCell.detail["Email"] = emailAddress
                } else {
                    NewGroupDetailCell.detail["Email"] = nil
                }
                break
            case 5:
                let selectedRow = pickerView.selectedRow(inComponent: 0)
                let selectedCategory = categoryArray[selectedRow]
                if selectedCategory != "" {
                    categoryTextField.text = selectedCategory
                    NewGroupDetailCell.detail["Category"] = selectedCategory
                } else {
                    categoryTextField.text = ""
                    NewGroupDetailCell.detail["Category"] = nil
                }
                break
            default:
                break
            }
            delegate.setGroupDetail(detail: NewGroupDetailCell.detail)
        }
    }
}
