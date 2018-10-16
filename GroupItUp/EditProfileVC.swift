//
//  EditProfileVC.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-05-30.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit
import Firebase

protocol EditProfileVCDelegate {
    func updateProfileDisplayImageFromEditProfileVC(image: UIImage)
    func updateUsernameFromEditProfileVC(newName: String)
}

class EditProfileVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ProfileDetailEditVCDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let editOption = ["Username", "Gender", "Region"]
    var selectedOption: String!
    var currentValue: String!
    var displayImage: UIImage!
    var imagePicker: UIImagePickerController!
    var delegate: EditProfileVCDelegate?
    var displayText: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return editOption.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileDisplayUpdateCell") as! ProfileDisplayUpdateCell
            cell.configureCell(image: displayImage)
            return cell
        } else {
            let selectedOption = editOption[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditProfileCell") as! EditProfileCell
            cell.configureCell(editOption: selectedOption)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            present(imagePicker, animated: true, completion: nil)
        } else {
            selectedOption = editOption[indexPath.row]
            displayText = ""
            switch selectedOption {
            case "Username":
                displayText = currentUser.username
                break
            case "Gender":
                if currentUser.gender != "" {
                    displayText = currentUser.gender
                }
                break
            case "Region":
                if currentUser.region != "" {
                    displayText = currentUser.region
                }
                break
            default:
                displayText = ""
            }
            performSegue(withIdentifier: "ProfileDetailEditVC", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ProfileDetailEditVC {
            destination.delegate = self
            destination.displayText = displayText
            destination.editOption = selectedOption
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        let selectedImage = (info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as! UIImage)
        displayImage = selectedImage
        currentUser.userDisplayImage = selectedImage
        
        if let delegate = self.delegate {
            delegate.updateProfileDisplayImageFromEditProfileVC(image: displayImage)
        }
        reloadSection(tableView: self.tableView, indexSection: 0)
        let imageData = selectedImage.jpegData(compressionQuality: 0.5)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        startRefreshing()
        Timer.scheduledTimer(withTimeInterval: 20, repeats: false, block: { (timer) in
            if isRefreshing == true {
                self.endRefrenshing()
                self.sendAlertWithoutHandler(alertTitle: "Error", alertMessage: "Time out, please re-send.", actionTitle: ["OK"])
                return
            }
        })
        DataService.ds.STORAGE_USER_IMAGE.child("\(currentUser.userID).jpg").putData(imageData!, metadata: metadata) { (metadata, error) in
            if error != nil {
                print("\(error?.localizedDescription)")
            } else {
                let url = metadata?.downloadURL()?.absoluteString
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.photoURL = URL(string: url!)
                changeRequest?.commitChanges(completion: { (error) in
                    if error != nil {
                        print("Error: \(error?.localizedDescription)")
                    } else {
                        currentUser.userDisplayImageURL = url!
                    }
                })
                DataService.ds.REF_USERS_CURRENT.child("User Display Photo URL").setValue(url!)
                self.endRefrenshing()
            }
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    
    func refreshData() {
        reloadSection(tableView: self.tableView, indexSection: 1)
        if let delegate = self.delegate {
            delegate.updateUsernameFromEditProfileVC(newName: currentUser.username)
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
