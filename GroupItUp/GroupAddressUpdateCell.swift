//
//  GroupAddressUpdateCell.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-05-24.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit

protocol GroupAddressUpdateCellDelegate {
    func updateGroupAddressForFirebase(address: Dictionary<String, String>)
    func updateGroupAddressForCurrentGroup(address: Address)
    func updateSelectedCountry(country: String)
    func getSelectedProvinces() -> [String]
}

class GroupAddressUpdateCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var provinceTextField: UITextField!
    @IBOutlet weak var postalTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    
    var delegate: GroupAddressUpdateCellDelegate?
    var addressFields = ["Street", "City", "Province", "Postal Code", "Country"]
    var countryPicker: UIPickerView!
    var provincePicker: UIPickerView!
    static var address = [String: String]()
    var currentGroup: Group!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        streetTextField.delegate = self
        cityTextField.delegate = self
        provinceTextField.delegate = self
        postalTextField.delegate = self
        countryTextField.delegate = self
    }
    
    func configureCell(group: Group) {
        
        if !group.groupDetail.groupMeetUpAddress.isEmpty() {
            streetTextField.text = group.groupDetail.groupMeetUpAddress.street
            cityTextField.text = group.groupDetail.groupMeetUpAddress.city
            provinceTextField.text = group.groupDetail.groupMeetUpAddress.province
            provinceTextField.inputView = provincePicker
            postalTextField.text = group.groupDetail.groupMeetUpAddress.postal
            countryTextField.text = group.groupDetail.groupMeetUpAddress.country
            var row = 0
            for i in 0..<countries.count {
                if countries[i] == group.groupDetail.groupMeetUpAddress.country {
                    row = i
                    break
                }
            }
            countryPicker.selectRow(row, inComponent: 0, animated: false)
            countryTextField.inputView = countryPicker
            if let delegate = self.delegate {
                delegate.updateSelectedCountry(country: group.groupDetail.groupMeetUpAddress.country)
            }
        } else {
            var row = 0
            for i in 0..<countries.count {
                if countries[i] == currentUser.region {
                    row = i
                    break
                }
            }
            countryPicker.selectRow(row, inComponent: 0, animated: false)
            countryTextField.inputView = countryPicker
            streetTextField.isEnabled = false
            cityTextField.isEnabled = false
            provinceTextField.isEnabled = false
            postalTextField.isEnabled = false
        }
        
    }
    
    func setCurrentGroup(group: Group) {
        currentGroup = group
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let delegate = self.delegate {
            let tag = textField.tag
            switch tag {
            case 0:
                if let street = streetTextField.text, street != "" {
                    GroupAddressUpdateCell.address["Street"] = street
                    currentGroup.groupDetail.groupMeetUpAddress.street = street
                    currentGroup.groupDetail.groupMeetUpAddress.resetAddress()
                }
                break
            case 1:
                if let city = cityTextField.text, city != "" {
                    GroupAddressUpdateCell.address["City"] = city
                    currentGroup.groupDetail.groupMeetUpAddress.city = city
                    currentGroup.groupDetail.groupMeetUpAddress.resetAddress()
                }
                break
            case 2:
                let selectedRow = provincePicker.selectedRow(inComponent: 0)
                let selectedProvinces = delegate.getSelectedProvinces()
                let selectedProvince = selectedProvinces[selectedRow]
                if selectedProvince != "" {
                    provinceTextField.text = selectedProvince
                    GroupAddressUpdateCell.address["Province"] = selectedProvince
                    currentGroup.groupDetail.groupMeetUpAddress.province = selectedProvince
                    currentGroup.groupDetail.groupMeetUpAddress.resetAddress()
                }
                break
            case 3:
                if let postal = postalTextField.text, postal != "" {
                    GroupAddressUpdateCell.address["Postal"] = postal
                    currentGroup.groupDetail.groupMeetUpAddress.postal = postal
                    currentGroup.groupDetail.groupMeetUpAddress.resetAddress()
                }
                break
            case 4:
                let selectedRow = countryPicker.selectedRow(inComponent: 0)
                let selectedCountry = countries[selectedRow]
                if selectedCountry != "" {
                    countryTextField.text = selectedCountry
                    GroupAddressUpdateCell.address["Country"] = selectedCountry
                    currentGroup.groupDetail.groupMeetUpAddress.country = selectedCountry
                    currentGroup.groupDetail.groupMeetUpAddress.resetAddress()
                    delegate.updateSelectedCountry(country: selectedCountry)
                    streetTextField.isEnabled = true
                    cityTextField.isEnabled = true
                    provinceTextField.isEnabled = true
                    postalTextField.isEnabled = true
                } else {
                    countryTextField.text = ""
                    GroupAddressUpdateCell.address["Country"] = ""
                    currentGroup.groupDetail.groupMeetUpAddress.country = ""
                    delegate.updateSelectedCountry(country: "")
                    streetTextField.isEnabled = false
                    streetTextField.text = ""
                    GroupAddressUpdateCell.address["Street"] = ""
                    currentGroup.groupDetail.groupMeetUpAddress.street = ""
                    cityTextField.isEnabled = false
                    cityTextField.text = ""
                    GroupAddressUpdateCell.address["City"] = ""
                    currentGroup.groupDetail.groupMeetUpAddress.city = ""
                    provinceTextField.isEnabled = false
                    provinceTextField.text = ""
                    GroupAddressUpdateCell.address["Province"] = ""
                    currentGroup.groupDetail.groupMeetUpAddress.province = ""
                    postalTextField.isEnabled = false
                    postalTextField.text = ""
                    GroupAddressUpdateCell.address["Postal"] = ""
                    currentGroup.groupDetail.groupMeetUpAddress.postal = ""
                    currentGroup.groupDetail.groupMeetUpAddress.resetAddress()
                }
                break
            default:
                break
            }
            delegate.updateGroupAddressForFirebase(address: GroupAddressUpdateCell.address)
            delegate.updateGroupAddressForCurrentGroup(address: currentGroup.groupDetail.groupMeetUpAddress)
        }
    }
}
