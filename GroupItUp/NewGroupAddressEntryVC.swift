//
//  NewGroupAddressEntryVC.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-06-18.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit

class NewGroupAddressEntryVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var provinceTextField: UITextField!
    @IBOutlet weak var postalTextField: UITextField!
    @IBOutlet weak var specifyAddressSwitch: UISwitch!
    
    var countryPicker: UIPickerView!
    var provincePicker: UIPickerView!
    var selectedCountry: String!
    var selectedProvinces: [String]!
    var textFields: [UITextField]!
    var setAddressNow: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFields = [self.countryTextField, self.streetTextField, self.cityTextField, self.provinceTextField, self.postalTextField]
        
        countryPicker = UIPickerView()
        countryPicker.delegate = self
        countryPicker.dataSource = self
        
        provincePicker = UIPickerView()
        provincePicker.delegate = self
        provincePicker.dataSource = self
        
        countryTextField.inputView = countryPicker
        provinceTextField.inputView = provincePicker
        
        streetTextField.delegate = self
        cityTextField.delegate = self
        provinceTextField.delegate = self
        postalTextField.delegate = self
        countryTextField.delegate = self
        
        initialize()
    }
    
    func initialize() {
        if setAddressNow == true {
            streetTextField.text = newGroup.groupDetail.groupMeetUpAddress.street
            cityTextField.text = newGroup.groupDetail.groupMeetUpAddress.city
            provinceTextField.text = newGroup.groupDetail.groupMeetUpAddress.province
            postalTextField.text = newGroup.groupDetail.groupMeetUpAddress.postal
            countryTextField.text = newGroup.groupDetail.groupMeetUpAddress.country
            selectedCountry = newGroup.groupDetail.groupMeetUpAddress.country
        } else {
            for textField in textFields {
                textField.isEnabled = false
            }
        }
        
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.isEqual(countryPicker) {
            return countries.count
        } else {
            if countryTextField.text != "" {
                for country in countries_provinces.keys {
                    if country == selectedCountry {
                        selectedProvinces = countries_provinces[country] as! [String]
                        break
                    }
                }
                return selectedProvinces.count
            } else {
                return 0
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.isEqual(countryPicker) {
            return countries[row]
        } else {
            return selectedProvinces[row]
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 4 {
            var row = 0
            for i in 0..<countries.count {
                if countries[i] == currentUser.region {
                    row = i
                    break
                }
            }
            countryPicker.selectRow(row, inComponent: 0, animated: false)
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let tag = textField.tag
        switch tag {
        case 0:
            if let street = streetTextField.text, street != "" {
                newGroup.groupDetail.groupMeetUpAddress.street = street
                newGroupAddressForFirebase["Street"] = street
            } else {
                newGroup.groupDetail.groupMeetUpAddress.street = ""
                newGroupAddressForFirebase["Street"] = nil
            }
            newGroupDetailForFirebase["Address"] = newGroupAddressForFirebase
            break
        case 1:
            if let city = cityTextField.text, city != "" {
                newGroup.groupDetail.groupMeetUpAddress.city = city
                newGroupAddressForFirebase["City"] = city
            } else {
                newGroup.groupDetail.groupMeetUpAddress.city = ""
                newGroupAddressForFirebase["City"] = nil
            }
            newGroupDetailForFirebase["Address"] = newGroupAddressForFirebase
            break
        case 2:
            let selectedRow = provincePicker.selectedRow(inComponent: 0)
            if !selectedProvinces.isEmpty {
                let selectedProvince = selectedProvinces[selectedRow]
                if selectedProvince != "" {
                    provinceTextField.text = selectedProvince
                    newGroup.groupDetail.groupMeetUpAddress.province = selectedProvince
                    newGroupAddressForFirebase["Province"] = selectedProvince
                } else {
                    provinceTextField.text = ""
                    newGroup.groupDetail.groupMeetUpAddress.province = selectedProvince
                    newGroupAddressForFirebase["Province"] = nil
                }
                newGroupDetailForFirebase["Address"] = newGroupAddressForFirebase
            }
            break
        case 3:
            if let postal = postalTextField.text, postal != "" {
                newGroup.groupDetail.groupMeetUpAddress.postal = postal
                newGroupAddressForFirebase["Postal"] = postal
            } else {
                newGroup.groupDetail.groupMeetUpAddress.street = ""
                newGroupAddressForFirebase["Postal"] = nil
            }
            newGroupDetailForFirebase["Address"] = newGroupAddressForFirebase
            break
        case 4:
            let selectedRow = countryPicker.selectedRow(inComponent: 0)
            selectedCountry = countries[selectedRow]
            if selectedCountry != "" {
                countryTextField.text = selectedCountry
                streetTextField.isEnabled = true
                streetTextField.backgroundColor = UIColor.white
                cityTextField.isEnabled = true
                cityTextField.backgroundColor = UIColor.white
                provinceTextField.isEnabled = true
                provinceTextField.backgroundColor = UIColor.white
                postalTextField.isEnabled = true
                postalTextField.backgroundColor = UIColor.white
                newGroup.groupDetail.groupMeetUpAddress.country = selectedCountry
                newGroupAddressForFirebase["Country"] = selectedCountry
            } else {
                countryTextField.text = ""
                streetTextField.text = ""
                streetTextField.isEnabled = false
                streetTextField.backgroundColor = UIColor.lightGray
                cityTextField.text = ""
                cityTextField.isEnabled = false
                cityTextField.backgroundColor = UIColor.lightGray
                provinceTextField.text = ""
                provinceTextField.isEnabled = false
                provinceTextField.backgroundColor = UIColor.lightGray
                postalTextField.text = ""
                postalTextField.isEnabled = false
                postalTextField.backgroundColor = UIColor.lightGray
                newGroup.groupDetail.groupMeetUpAddress.country = ""
                newGroup.groupDetail.groupMeetUpAddress.street = ""
                newGroup.groupDetail.groupMeetUpAddress.city = ""
                newGroup.groupDetail.groupMeetUpAddress.province = ""
                newGroup.groupDetail.groupMeetUpAddress.postal = ""
                newGroupAddressForFirebase["Country"] = nil
                newGroupAddressForFirebase["Street"] = nil
                newGroupAddressForFirebase["City"] = nil
                newGroupAddressForFirebase["Province"] = nil
                newGroupAddressForFirebase["Postal"] = nil
            }
            newGroupDetailForFirebase["Address"] = newGroupAddressForFirebase
            break
        default:
            break
        }
        setAddress(address: newGroup.groupDetail.groupMeetUpAddress)
        
    }
    
    func setAddress(address: Address) {
        if !address.isEmpty() {
            let street = address.street
            let city = address.city
            let province = address.province
            let postal = address.postal
            let country = address.country
            newGroup.groupDetail.groupMeetUpAddress.address = "\(street), \(city), \(province), \(postal), \(country)"
        } else {
            newGroup.groupDetail.groupMeetUpAddress.address = ""
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
        if setAddressNow == true {
         performValidation()   
        }
        performSegue(withIdentifier: "NewGroupPreviousPhotosVC", sender: nil)
    }
    
    @IBAction func switchPressed(_ sender: UISwitch) {
        if specifyAddressSwitch.isOn {
            setAddressNow = true
            countryTextField.isEnabled = true
        } else {
            setAddressNow = false
            for textField in textFields {
                textField.text = ""
                textField.isEnabled = false
            }
            resetAddress()
        }
    }
    
    func resetAddress() {
        newGroup.groupDetail.groupMeetUpAddress = Address()
        newGroupAddressForFirebase.removeAll()
    }
}
