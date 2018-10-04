//
//  LocationSearchVC.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-04-29.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit

class LocationSearchVC: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var provinceTextField: UITextField!
    @IBOutlet weak var provinceSpliterView: UIView!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var citySpliterView: UIView!
    
    var selectedOption: String!
    var locationValue: Dictionary<String, String>!
    var countryPicker: UIPickerView!
    var provincePicker: UIPickerView!
    var selectedProvinces = [String]()
    var selectedCountry: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }
    
    func initialize() {
        self.title = selectedOption
        let allTextFields = [countryTextField, provinceTextField, cityTextField]
        configureTextFieldWithoutImage(textFields: allTextFields as! [UITextField])
        for textField in allTextFields {
            textField?.delegate = self
        }
        
        switch selectedOption {
        case "Province":
            provinceTextField.isHidden = false
            provinceSpliterView.isHidden = false
            provinceTextField.isEnabled = false
            provinceTextField.backgroundColor = UIColor.lightGray
            break
        case "City":
            provinceTextField.isHidden = false
            provinceSpliterView.isHidden = false
            provinceTextField.isEnabled = false
            provinceTextField.backgroundColor = UIColor.lightGray
            cityTextField.isHidden = false
            citySpliterView.isHidden = false
            cityTextField.isEnabled = false
            cityTextField.backgroundColor = UIColor.lightGray
            break
        default:
            break
        }
        
        countryPicker = UIPickerView()
        countryPicker.delegate = self
        countryPicker.dataSource = self
        
        provincePicker = UIPickerView()
        provincePicker.delegate = self
        provincePicker.dataSource = self
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let tag = textField.tag
        switch tag {
        case 0:
            var row = 0
            for i in 0..<countries.count {
                if countries[i] == currentUser.region {
                    row = i
                    selectedCountry = countries[i]
                    break
                }
            }
            countryPicker.selectRow(row, inComponent: 0, animated: false)
            countryTextField.inputView = countryPicker
            
            break
        case 1:
            
            provinceTextField.inputView = provincePicker
            break
            
        default:
            break
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let tag = textField.tag
        switch tag {
        case 0:
            let selectedRow = countryPicker.selectedRow(inComponent: 0)
            selectedCountry = countries[selectedRow]
            if selectedCountry != "" {
                countryTextField.text = selectedCountry
                provinceTextField.text = ""
                provinceTextField.isEnabled = true
                provinceTextField.backgroundColor = UIColor.clear
                cityTextField.text = ""
                cityTextField.isEnabled = true
                cityTextField.backgroundColor = UIColor.clear
            } else {
                countryTextField.text = ""
                provinceTextField.text = ""
                provinceTextField.isEnabled = false
                provinceTextField.backgroundColor = UIColor.lightGray
                cityTextField.text = ""
                cityTextField.isEnabled = false
                cityTextField.backgroundColor = UIColor.lightGray
            }
            
            break
        case 1:
            let selectedRow = provincePicker.selectedRow(inComponent: 0)
            if selectedProvinces.count > 0 {
                let selectedProvince = selectedProvinces[selectedRow]
                provinceTextField.text = selectedProvince
            }
            break
            
        default:
            break
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView .isEqual(countryPicker) {
            return countries.count
        } else {
            let selectedCountry = countryTextField.text
            if selectedCountry != "" {
                
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.isEqual(countryPicker) {
            let selectedRow = countryPicker.selectedRow(inComponent: 0)
            let selectedCountry = countries[selectedRow]
            if selectedCountry != "" {
                countryTextField.text = selectedCountry
                provinceTextField.text = ""
                provinceTextField.isEnabled = true
                provinceTextField.backgroundColor = UIColor.clear
                cityTextField.text = ""
                cityTextField.isEnabled = true
                cityTextField.backgroundColor = UIColor.clear
            } else {
                countryTextField.text = ""
                provinceTextField.text = ""
                provinceTextField.isEnabled = false
                provinceTextField.backgroundColor = UIColor.lightGray
                cityTextField.text = ""
                cityTextField.isEnabled = false
                cityTextField.backgroundColor = UIColor.lightGray
            }
        } else {
            let selectedRow = provincePicker.selectedRow(inComponent: 0)
            if selectedProvinces.count > 0 {
                let selectedProvince = selectedProvinces[selectedRow]
                provinceTextField.text = selectedProvince
            }
        }
    }

    @IBAction func searchBtnPressed(_ sender: UIButton) {
        if selectedOption == "Country" {
            guard let country = countryTextField.text, country != "" else {
                self.sendAlertWithoutHandler(alertTitle: "Missing Information", alertMessage: "Please fill in the country you are interested in.", actionTitle: ["Cancel"])
                return
            }
            locationValue = ["Country": country]
        } else if selectedOption == "Province" {
            guard let country = countryTextField.text, country != "" else {
                self.sendAlertWithoutHandler(alertTitle: "Missing Information", alertMessage: "Please fill in the country you are interested in.", actionTitle: ["Cancel"])
                return
            }
            
            guard let province = provinceTextField.text, province != "" else {
                self.sendAlertWithoutHandler(alertTitle: "Missing Information", alertMessage: "Please fill in the province you are interested in.", actionTitle: ["Cancel"])
                return
            }
            locationValue = ["Country": country, "Province": province.lowercased()]
        } else {
            guard let country = countryTextField.text, country != "" else {
                self.sendAlertWithoutHandler(alertTitle: "Missing Information", alertMessage: "Please fill in the country you are interested in.", actionTitle: ["Cancel"])
                return
            }
            
            guard let province = provinceTextField.text, province != "" else {
                self.sendAlertWithoutHandler(alertTitle: "Missing Information", alertMessage: "Please fill in the province you are interested in.", actionTitle: ["Cancel"])
                return
            }
            
            guard let city = cityTextField.text, city != "" else {
                self.sendAlertWithoutHandler(alertTitle: "Missing Information", alertMessage: "Please fill in the city you are interested in.", actionTitle: ["Cancel"])
                return
            }
            locationValue = ["Country": country, "Province": province.lowercased(), "City": city.lowercased()]
        }
        performSegue(withIdentifier: "SearchResultVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SearchResultVC {
            destination.selectedOption = selectedOption
            destination.locationValue = locationValue
            
        }
    }
}
