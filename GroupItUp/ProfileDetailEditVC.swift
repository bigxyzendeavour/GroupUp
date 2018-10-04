//
//  ProfileDetailEditVC.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-05-31.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit
import Firebase

protocol ProfileDetailEditVCDelegate {
    func refreshData()
}

class ProfileDetailEditVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var individualDetailTextField: UITextField!

    var displayText: String!
    var editOption: String!
    var pickerView: UIPickerView!
    let genderSelection = ["", "Male", "Female"]
    var countryPicker: UIPickerView!
    var delegate: ProfileDetailEditVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        countryPicker = UIPickerView()
        countryPicker.delegate = self
        countryPicker.dataSource = self
        
        individualDetailTextField.delegate = self
        individualDetailTextField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        initialize(currentValue: displayText)
    }
    
    func initialize(currentValue: String) {
        if currentValue != "" {
            individualDetailTextField.text = currentValue
        }
        individualDetailTextField.placeholder = editOption
        
        switch editOption {
        case "Gender":
            individualDetailTextField.inputView = pickerView
            break
        case "Region":
            
            individualDetailTextField.inputView = countryPicker
            break
        default:
            break
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch editOption {
        case "Gender":
            var row: Int
            if currentUser.gender == "" {
                row = 0
            } else if currentUser.gender == "Male" {
                row = 1
            } else {
                row = 2
            }
            pickerView.selectRow(row, inComponent: 0, animated: true)
            break
        case "Region":
            var row = 0
            for i in 0..<countries.count {
                if countries[i] == currentUser.region {
                    row = i
                    break
                }
            }
            countryPicker.selectRow(row, inComponent: 0, animated: false)
            break
        default:
            break
        }
        return true
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.isEqual(countryPicker) {
            return countries.count
        }
        return genderSelection.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.isEqual(countryPicker) {
            return countries[row]
        }
        return genderSelection[row]
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch editOption {
        case "Username":
            if let newName = individualDetailTextField.text, newName != "" {
                currentUser.username = newName
                DataService.ds.REF_USERS_CURRENT.child("Username").setValue(newName)
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = newName
                changeRequest?.commitChanges(completion: { (error) in
                    if error != nil {
                        print("Error: \(error?.localizedDescription)")
                    }
                    
                })
            }
            break
        case "Gender":
            let selectedRow = pickerView.selectedRow(inComponent: 0)
            let newGender = genderSelection[selectedRow]
            individualDetailTextField.text = newGender
            currentUser.gender = newGender
            DataService.ds.REF_USERS_CURRENT.child("Gender").setValue(newGender)
            break
        case "Region":
            let selectedRow = countryPicker.selectedRow(inComponent: 0)
            let newRegion = countries[selectedRow]
            individualDetailTextField.text = newRegion
            currentUser.region = newRegion
            DataService.ds.REF_USERS_CURRENT.child("Region").setValue(newRegion)
            break
        default:
            break
        }
        if let delegate = self.delegate {
            delegate.refreshData()
        }
    }
   
}
