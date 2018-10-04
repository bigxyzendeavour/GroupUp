//
//  SettingVC.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-05-15.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit
import OpalImagePicker

protocol SettingVCDelegate {
    func updateDisplayImageFromSettingVC(image: UIImage)
    func updateGroupStatus(status: String)
    func updatePreviousGroupPhotos(groupPhotos: [UIImage])
    func updateGroupDetail(detail: GroupDetail)
    func updateGroupAddress(address: Address)
}

class SettingVC: UIViewController, UITableViewDelegate, UITableViewDataSource, DisplayPhotoUpdateVCDelegate, OpalImagePickerControllerDelegate, GroupDetailUpdateVCDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cancelButton: UIButton!
    
    let CANCEL_STATUS = "Cancelled"
    let PLANNING_STATUS = "Planning"
    let COMPLETED_STATUS = "Completed"
    
    var currentGroup: Group!
    let settingOptions = ["Update display photo", "Update group detail", "Update previous group photos"]
    var displayImage: UIImage!
    var delegate: SettingVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        if currentGroup.groupDetail.groupStatus == CANCEL_STATUS {
            cancelButton.setTitle("Activate Group", for: .normal)
        } else if currentGroup.groupDetail.groupStatus == COMPLETED_STATUS {
            cancelButton.isEnabled = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let delegate = self.delegate
        if displayImage != nil {
            delegate?.updateDisplayImageFromSettingVC(image: displayImage)
        }
        
    }

    @IBAction func cancelBtnPressed(_ sender: UIButton) {
        let yesActionHandler = {(action: UIAlertAction) -> Void in
            if self.currentGroup.groupDetail.groupStatus == self.CANCEL_STATUS {
                sender.setTitle("Cancel Group", for: .normal)
                let delegate = self.delegate
                delegate?.updateGroupStatus(status: self.PLANNING_STATUS)
                self.sendAlertWithoutHandler(alertTitle: "Activate Group", alertMessage: "The group has been activated, the status is now \"Planning\".", actionTitle: ["OK"])
                DataService.ds.REF_GROUPS.child(self.currentGroup.groupID).child("Group Detail").child("Status").setValue(self.PLANNING_STATUS)
            } else if self.currentGroup.groupDetail.groupStatus == self.PLANNING_STATUS {
                sender.setTitle("Activate Group", for: .normal)
                let delegate = self.delegate
                delegate?.updateGroupStatus(status: self.CANCEL_STATUS)
                self.sendAlertWithoutHandler(alertTitle: "Cancel Group", alertMessage: "The group has been cancelled, the status is now \"Cancelled\".", actionTitle: ["OK"])
                DataService.ds.REF_GROUPS.child(self.currentGroup.groupID).child("Group Detail").child("Status").setValue(self.CANCEL_STATUS)
            }
        }
        let cancelActionHandler = {(action: UIAlertAction) -> Void in
            return
        }
        if currentGroup.groupDetail.groupStatus == self.PLANNING_STATUS {
            sendAlertWithHandler(alertTitle: "Cancel Group Warning", alertMessage: "The group status is going to be set to Cancelled, are you sure to continue?", actionTitle: ["Yes", "Cancel"], handlers: [yesActionHandler, cancelActionHandler])
        } else if currentGroup.groupDetail.groupStatus == self.CANCEL_STATUS {
            sendAlertWithHandler(alertTitle: "Activate Group Warning", alertMessage: "The group status is going to be set to Planning, are you sure to continue?", actionTitle: ["Yes", "Cancel"], handlers: [yesActionHandler, cancelActionHandler])
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell") as! SettingCell
        let option = settingOptions[indexPath.row]
        cell.configureCell(option: option)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            performSegue(withIdentifier: "DisplayPhotoUpdateVC", sender: nil)
        } else if indexPath.row == 1 {
            performSegue(withIdentifier: "GroupDetailUpdateVC", sender: nil)
        } else {
            let opalImagePicker = OpalImagePickerController()
            opalImagePicker.imagePickerDelegate = self
            opalImagePicker.maximumSelectionsAllowed = 10
            self.present(opalImagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingImages images: [UIImage]) {
        let delegate = self.delegate
        delegate?.updatePreviousGroupPhotos(groupPhotos: images)
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DisplayPhotoUpdateVC {
            destination.currentGroup = currentGroup
            destination.delegate = self
        }
        if let destination = segue.destination as? GroupDetailUpdateVC {
            destination.currentGroup = currentGroup
        }
    }
    
    func updateDisplayImage(image: UIImage) {
        displayImage = image
    }
    
    func updateGroupDetailFromGroupDetailUpdateVC(detail: GroupDetail) {
        currentGroup.groupDetail = detail
        if let delegate = self.delegate {
            delegate.updateGroupDetail(detail: currentGroup.groupDetail)
        }
    }
    
    func updateGroupAddressFromGroupDetailUpdateVC(address: Address) {
        if let delegate = self.delegate {
            delegate.updateGroupAddress(address: address)
        }
    }
}
