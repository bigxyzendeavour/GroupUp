//
//  NewGroupDetailVC.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-06-18.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit

class NewGroupDetailVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var maxAttendentsTextField: UITextField!
    @IBOutlet weak var meetUpTimeTextField: UITextField!
    @IBOutlet weak var contactTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    
    var datePicker: UIDatePicker!
    var pickerView: UIPickerView!
    let categoryArray = ["", "Sport", "Entertainment", "Travel", "Food", "Study", "Other"]
    var textFields: [UITextField]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        maxAttendentsTextField.delegate = self
        meetUpTimeTextField.delegate = self
        contactTextField.delegate = self
        phoneTextField.delegate = self
        emailTextField.delegate = self
        categoryTextField.delegate = self
        
        maxAttendentsTextField.keyboardType = .numberPad
        emailTextField.keyboardType = .emailAddress
        phoneTextField.keyboardType = .phonePad
        
        datePicker = UIDatePicker()
        datePicker.minimumDate = NSDate() as Date
        meetUpTimeTextField.inputView = datePicker
        pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        categoryTextField.inputView = pickerView
        
        textFields = [self.maxAttendentsTextField, self.meetUpTimeTextField, self.contactTextField, self.phoneTextField, self.categoryTextField]
        
        initialize()
        
    }
    
    func initialize() {
        if newGroup.groupDetail.groupMaxMembers == 0 {
            maxAttendentsTextField.text = ""
        } else {
            maxAttendentsTextField.text = "\(newGroup.groupDetail.groupMaxMembers)"
        }
        meetUpTimeTextField.text = newGroup.groupDetail.groupMeetingTime
        contactTextField.text = newGroup.groupDetail.groupContact
        phoneTextField.text = newGroup.groupDetail.groupContactPhone
        emailTextField.text = newGroup.groupDetail.groupContactEmail
        categoryTextField.text = newGroup.groupDetail.groupCategory
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryArray[row]
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let tag = textField.tag
        switch tag {
        case 0:
            if let max = Int(maxAttendentsTextField.text!) {
                newGroup.groupDetail.groupMaxMembers = max
                newGroupDetailForFirebase["Max Attending Members"] = max
            } else {
                newGroup.groupDetail.groupMaxMembers = 0
                newGroupDetailForFirebase["Max Attending Members"] = nil
            }
            break
        case 1:
            let selectedDate = datePicker.date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            let date = dateFormatter.string(from: selectedDate as Date)
            meetUpTimeTextField.text = date
            newGroup.groupDetail.groupMeetingTime = date
            newGroupDetailForFirebase["Time"] = date
            break
        case 2:
            let contactPerson = contactTextField.text
            if contactPerson != "" {
                newGroup.groupDetail.groupContact = contactPerson!
                newGroupDetailForFirebase["Contact"] = contactPerson
            } else {
                newGroup.groupDetail.groupContact = ""
                newGroupDetailForFirebase["Contact"] = nil
            }
            break
        case 3:
            if let phoneNumber = phoneTextField.text {
                if phoneNumber != "" {
                    newGroup.groupDetail.groupContactPhone = phoneNumber
                    newGroupDetailForFirebase["Phone"] = phoneNumber
                } else {
                    newGroup.groupDetail.groupContactPhone = ""
                    newGroupDetailForFirebase["Phone"] = nil
                }
            }
            break
        case 4:
            let emailAddress = emailTextField.text
            if emailAddress != "" {
                newGroup.groupDetail.groupContactEmail = emailAddress!
                newGroupDetailForFirebase["Email"] = emailAddress
            } else {
                newGroup.groupDetail.groupContactEmail = ""
                newGroupDetailForFirebase["Email"] = nil
            }
            break
        case 5:
            let selectedRow = pickerView.selectedRow(inComponent: 0)
            let selectedCategory = categoryArray[selectedRow]
            if selectedCategory != "" {
                categoryTextField.text = selectedCategory
                newGroup.groupDetail.groupCategory = selectedCategory
                newGroupDetailForFirebase["Category"] = selectedCategory
            } else {
                categoryTextField.text = selectedCategory
                newGroup.groupDetail.groupCategory = ""
                newGroupDetailForFirebase["Category"] = nil
            }
            break
        default:
            break
        }
    }

    func performValidation() {
        for textField in textFields {
            if textField.text == "" {
                sendAlertWithoutHandler(alertTitle: "Missing Information", alertMessage: "Please specify the \(textField.placeholder!)", actionTitle: ["OK"])
            }
        }
    }
    
    @IBAction func nextBtnPressed(_ sender: UIButton) {
        performValidation()
        performSegue(withIdentifier: "NewGroupAddressEntryVC", sender: nil)
    }
}
