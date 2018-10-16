//
//  NewGroupCreationVC.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-05-03.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit
import OpalImagePicker
import Firebase
import IQKeyboardManagerSwift

class NewGroupCreationVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, NewGroupDescriptionCellDelegate, NewGroupCreateBtnCellDelegate, NewGroupDetailCellDelegate, OpalImagePickerControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, NewGroupPreviousPhotoCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var imagePicker: UIImagePickerController!
    var groupCreatingInProgress: Group!
    var selectedIndex: Int!
    var selectedImage: UIImage?
    var groupTitle: String!
    var groupDescription: String!
    var groupDetail: Dictionary<String, Any>!
    var groupPreviousPhotos: [Photo]?
    var allowEmptyGroupDisplayImage: Bool!
    var previousPhotos = [UIImage]()
    var groupMeetingAddress: Address!
    var groupDetailForGroup: GroupDetail!

    
    override func viewWillAppear(_ animated: Bool) {
//        reloadSection(tableView: self.tableView, indexSection: 4)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
//        tableView.estimatedRowHeight = tableView.rowHeight
//        tableView.rowHeight = UITableViewAutomaticDimension

        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
//        groupDetail = [String: Any]()
        
    }
    
    @IBAction func nextBtnPressed(_ sender: UIButton) {
        if newGroup.groupDetail.groupTitle == "" {
            sendAlertWithoutHandler(alertTitle: "Missing Title", alertMessage: "Please give a title to your group event", actionTitle: ["Cancel"])
            return
        } else {
            newGroupDetailForFirebase["Title"] = newGroup.groupDetail.groupTitle
        }
        
        if newGroup.groupDetail.groupDetailDescription == "" {
            sendAlertWithoutHandler(alertTitle: "Error", alertMessage: "Please give a description to your group event", actionTitle: ["Cancel"])
            return
        } else {
            newGroupDetailForFirebase["Detail Description"] = newGroup.groupDetail.groupDetailDescription
        }
        
        if selectedImage == UIImage(named: "emptyImage") || selectedImage == nil {
            self.selectedImage = UIImage(named: "emptyImage")
            let yesActionHandler = {(action: UIAlertAction) -> Void in
                newGroup.groupDetail.groupDisplayImage = self.selectedImage!
                self.performSegue(withIdentifier: "NewGroupDetailVC", sender: nil)
            }
            let cancelActionHandler = {(action: UIAlertAction) -> Void in
                return
            }
            sendAlertWithHandler(alertTitle: "Missing Display Image", alertMessage: "The group event doesn't have a display image, are you sure to continue? You can add one later on.", actionTitle: ["Yes", "Cancel"], handlers: [yesActionHandler, cancelActionHandler])
        } else {
            newGroup.groupDetail.groupDisplayImage = self.selectedImage!
            performSegue(withIdentifier: "NewGroupDetailVC", sender: nil)
        }
    }
    
    @IBAction func deleteBtnPressed(_ sender: UIButton) {
        selectedImage = UIImage(named: "emptyImage")
        newGroup.groupDetail.groupDisplayImage = UIImage(named: "emptyImage")!
        reloadSection(tableView: self.tableView, indexSection: 0)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "NewGroupDisplayCell") as? NewGroupDisplayCell {
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
                tapGesture.numberOfTapsRequired = 1
                cell.groupDisplayImageView.addGestureRecognizer(tapGesture)
                cell.groupDisplayImageView.isUserInteractionEnabled = true
                if selectedImage != nil {
                    cell.configureCell(groupDisplayImage: selectedImage!)
                }
                return cell
            }
            return UITableViewCell()
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewGroupDescriptionCell") as! NewGroupDescriptionCell
            cell.delegate = self
            return cell
        }
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.section == 1 {
//            return 190
//        }
//        return tableView.rowHeight
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.section == 3 {
            let opalImagePicker = OpalImagePickerController()
            opalImagePicker.imagePickerDelegate = self
//            opalImagePicker.maximumSelectionsAllowed = 10
//            self.present(opalImagePicker, animated: true, completion: nil)
//        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if section == 2 {
//            return 30
//        } else {
            return CGFloat.leastNormalMagnitude
//        }
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if section == 2 {
//            return "Let's meet at"
//        } else {
//            return ""
//        }
//    }
    

    
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        if pickerView.isEqual(countryPicker) {
//            return countries.count
//        } else if pickerView.isEqual(provincePicker) {
//            if selectedCountry != "" && selectedCountry != nil {
//                for country in countries_provinces.keys {
//                    if country == selectedCountry {
//                        selectedProvinces = countries_provinces[country] as! [String]
//                        break
//                    }
//                }
//                return selectedProvinces.count
//            } else {
//                return 0
//            }
//        }
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        if pickerView.isEqual(countryPicker) {
//            return countries[row]
//        } else if pickerView.isEqual(provincePicker) {
//            return selectedProvinces[row]
//        }
//    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        selectedImage = (info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as! UIImage)
        newGroup.groupDetail.groupDisplayImage = selectedImage!
        reloadSection(tableView: self.tableView, indexSection: selectedIndex)
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: tableView)
        let ip = tableView.indexPathForRow(at: location)!
        selectedIndex = ip.row
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return previousPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewGroupPreviousPhotoCollectionCell", for: indexPath) as! NewGroupPreviousPhotoCollectionCell
        let photo = previousPhotos[indexPath.row]
        cell.configureCell(image: photo)
        return cell

    }
    
    func setGroupTitle(title: String) {
        groupTitle = title
    }
    
    func getGroupTitle() -> String {
        if groupTitle == nil  {
            return ""
        }
        return groupTitle
    }
    
    func getGroupDisplayImage() -> UIImage {
        if selectedImage == nil {
            return UIImage(named: "emptyImage")!
        }
        return selectedImage!
    }
    
    func setGroupDescription(description: String) {
        groupDescription = description
    }
    
    func getGroupDescription() -> String {
        if groupDescription == nil {
            return ""
        }
        print(groupDescription)
        return groupDescription!
    }
    
    func setGroupDetail(detail: Dictionary<String, Any>) {
        groupDetail = detail as Dictionary<String, Any>
    }

    func getGroupDetail() -> Dictionary<String, Any> {
        if groupDetail == nil {
            return [String: Any]()
        }
        return groupDetail
    }
    
    func getGroupDetailForGroup() -> GroupDetail {
        if groupDetailForGroup == nil {
            groupDetailForGroup = GroupDetail()
        }
        return groupDetailForGroup
    }
    
    func setAllowEmptyGroupDisplayImage(allow: Bool) {
        allowEmptyGroupDisplayImage = allow
    }
    
    func resetPreviousPhotos() {
        previousPhotos.removeAll()
        reloadSection(tableView: self.tableView ,indexSection: 5)
    }
    
    func getPreviousGroupPhotos() -> [UIImage] {
        if previousPhotos.count > 0 {
            return previousPhotos
        }
        return [UIImage]()
    }
    
    func setAddress(address: Address) {
        if !address.isEmpty() {
            groupMeetingAddress = address
            let street = address.street
            let city = address.city
            let province = address.province
            let postal = address.postal
            let country = address.country
            groupMeetingAddress.address = "\(street), \(city), \(province), \(postal), \(country)"
        } else {
            groupMeetingAddress = nil
        }
    }
    
    func getGroupMeetingAddress() -> Dictionary<String, Any> {
        if groupMeetingAddress != nil {
            let street = groupMeetingAddress.street
            let city = groupMeetingAddress.city
            let province = groupMeetingAddress.province
            let postal = groupMeetingAddress.postal
            let country = groupMeetingAddress.country
            let groupMeetingUpAddress = ["Street": street, "City": city, "Province": province, "Postal": postal, "Country": country]
            return groupMeetingUpAddress
        } else {
            return [String: Any]()
        }
    }
    
    func getGroupAddressForGroup() -> Address {
        return groupMeetingAddress
    }
    
    func setSelectedGroup(group: Group) {
        newGroup = group
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    func startActivityIndicator() {
        startRefreshing()
        Timer.scheduledTimer(withTimeInterval: 20, repeats: false, block: { (timer) in
            if isRefreshing == true {
                self.endRefrenshing()
                self.sendAlertWithoutHandler(alertTitle: "Error", alertMessage: "Time out, please send again", actionTitle: ["OK"])
                return
            }
        })
        
    }
    
    func stopActivityIndicator() {
        endRefrenshing()
    }
    
//    func setSelectedCountry(country: String) {
//        selectedCountry = country
//    }
//    
//    func getSelectedProvinces() -> [String] {
//        if selectedProvinces == nil {
//            selectedProvinces = [String]()
//        }
//        return selectedProvinces
//    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
