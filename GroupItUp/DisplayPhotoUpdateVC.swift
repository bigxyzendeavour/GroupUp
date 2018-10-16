//
//  DisplayPhotoUpdateVC.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-05-17.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit
import Firebase

protocol DisplayPhotoUpdateVCDelegate {
    func updateDisplayImage(image: UIImage)
}

class DisplayPhotoUpdateVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var displayImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var imagePicker: UIImagePickerController!
    var selectedImage: UIImage!
    var currentGroup: Group!
    var delegate: DisplayPhotoUpdateVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        let image = currentGroup.groupDetail.groupDisplayImage
        displayImageView.image = image
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        selectedImage = (info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as! UIImage)
        displayImageView.image = selectedImage
        activityIndicator.startAnimating()
        let groupID = currentGroup.groupID
        let imageData = selectedImage.jpegData(compressionQuality: 0.5)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        DataService.ds.STORAGE_GROUP_IMAGE.child(groupID).child("Display.jpg").putData(imageData!, metadata: metadata) { (metadata, error) in
            if error != nil {
                print("\(error?.localizedDescription)")
            } else {
                let url = metadata?.downloadURL()?.absoluteString
                DataService.ds.REF_GROUPS.child(groupID).child("Group Detail").child("Group Display Photo URL").setValue(url)
                let delegate = self.delegate
                delegate?.updateDisplayImage(image: self.selectedImage)
                self.activityIndicator.stopAnimating()
            }
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }

    @IBAction func settingBtnPressed(_ sender: UIBarButtonItem) {
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
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
