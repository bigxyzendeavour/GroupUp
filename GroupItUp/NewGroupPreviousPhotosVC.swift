//
//  NewGroupPreviousPhotosVC.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-06-18.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit
import OpalImagePicker
import Firebase

class NewGroupPreviousPhotosVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, OpalImagePickerControllerDelegate {
    
    @IBOutlet weak var selectedPhotoImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var createButton: UIButton!

    var previousPhotos = [Photo]()
    var isRefreshing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        tapGesture.numberOfTapsRequired = 1
        selectedPhotoImageView.addGestureRecognizer(tapGesture)
        selectedPhotoImageView.isUserInteractionEnabled = true
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: (self.view.frame.width - 30)/3, height: (self.view.frame.width - 30)/3)
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return previousPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewGroupPreviousPhotoCollectionCell", for: indexPath) as! NewGroupPreviousPhotoCollectionCell
        if previousPhotos.count > 0 {
            let photo = previousPhotos[indexPath.row]
            cell.configureCell(image: photo.photo)
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if previousPhotos.count > 0 {
            let selectedImage = previousPhotos[indexPath.item]
            selectedPhotoImageView.image = selectedImage.photo
        }
    }
    
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        let opalImagePicker = OpalImagePickerController()
        opalImagePicker.imagePickerDelegate = self
        opalImagePicker.maximumSelectionsAllowed = 10
        self.present(opalImagePicker, animated: true, completion: nil)
    }
    
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingImages images: [UIImage]) {
        previousPhotos.removeAll()
        collectionView.reloadData()
        selectedPhotoImageView.image = images[0]
        for i in 0..<images.count {
            var id = ""
            if i + 1 < 10 {
                id = "0\(i + 1)"
            } else {
                id = "\(i + 1)"
            }
            
            let photo = Photo()
            photo.photoID = id
            photo.photo = images[i]
            previousPhotos.append(photo)
        }
        newGroup.groupPhotos = previousPhotos
        picker.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? NewGroupCreationCompletedVC {
            destination.newCreatedGroup = true
        }
    }
    
    @IBAction func deleteBtnPressed(_ sender: UIButton) {
        previousPhotos.removeAll()
        selectedPhotoImageView.image = UIImage(named: "emptyImage")
        collectionView.reloadData()
    }
    
    @IBAction func createBtnPressed(_ sender: UIButton) {
        startRefreshing()
        createPost()
        
        
    }
    
    func createPost() {
        createButton.isEnabled = false
        DataService.ds.REF_GROUPS.observeSingleEvent(of: .value, with: { (snapshot) -> Void in
            if let snapShot = snapshot.children.allObjects as? [DataSnapshot] {
                var groupID: String
                let count = snapShot.count
                groupID = self.createGroupID(count: count)
                newGroup.groupID = groupID
                newGroup.groupDetail.groupID = groupID
                newGroup.groupDetail.groupCreationDate = "\(NSDate().fullTimeCreated())"
                self.setDefaultNewGroupDetailForFirebase()
//                newGroupForFirebase["Group Detail"] = newGroupDetailForFirebase
                DataService.ds.REF_GROUPS.child(groupID).child("Group Detail").setValue(newGroupDetailForFirebase)
                
                let displayID = "Display.jpg"
                let imageData = newGroup.groupDetail.groupDisplayImage.jpegData(compressionQuality: 0.5)
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpeg"
                DataService.ds.STORAGE_GROUP_IMAGE.child(groupID).child(displayID).putData(imageData!, metadata: metadata, completion: { (metadata, error) in
                    if error != nil {
                        self.endRefrenshing()
                        self.sendAlertWithoutHandler(alertTitle: "Error", alertMessage: "\(error!.localizedDescription)", actionTitle: ["Cancel"])
                        
                    } else {
                        let url = metadata?.downloadURL()?.absoluteString
                        newGroupDetailForFirebase["Group Display Photo URL"] = url
                        DataService.ds.REF_GROUPS.child(groupID).child("Group Detail").child("Group Display Photo URL").setValue(url)
                        
                        //Update current Group object
                        newGroup.groupDetail.groupDisplayImageURL = url!
                        self.endRefrenshing()
                    }
                })
                
                if !newGroup.groupPhotos.isEmpty {
                    for photo in newGroup.groupPhotos {
                        let image = photo.photo
                        let imageData = image.jpegData(compressionQuality: 0.5)
                        let imageUid = photo.photoID
                        let metadata = StorageMetadata()
                        metadata.contentType = "image/jpeg"
                        DataService.ds.STORAGE_GROUP_IMAGE.child(groupID).child("\(imageUid).jpg").putData(imageData!, metadata: metadata, completion: { (metadata, error) in
                            if error != nil {
                                self.sendAlertWithoutHandler(alertTitle: "Error", alertMessage: "\(error!.localizedDescription)", actionTitle: ["Cancel"])
                                
                            } else {
                                let url = metadata?.downloadURL()?.absoluteString
                                photo.photoURL = url!
                                DataService.ds.REF_GROUPS.child(groupID).child("Previous Photos").child(imageUid).setValue(url)
                            }
                            
                        })
                    }
                    
                }
                DataService.ds.REF_USERS_CURRENT.child("Attending").child(groupID).setValue(true)
                DataService.ds.REF_USERS_CURRENT.child("Hosting").child(groupID).setValue(true)
                self.createButton.isEnabled = true
                self.endRefrenshing()
                self.performSegue(withIdentifier: "NewGroupCreationCompletedVC", sender: nil)
            }
        })
    }
    
    func createGroupID(count: Int) -> String{
        var groupID: String
        if count < 9 {
            groupID = "0\(count + 1)"
        } else {
            groupID = "\(count + 1)"
        }
        return groupID
    }
    
    func setDefaultNewGroupDetailForFirebase() {
        newGroupDetailForFirebase["Attending"] = newGroup.groupDetail.groupAttending
        newGroupDetailForFirebase["Attending Users"] = newGroup.groupDetail.groupAttendingUsers
        newGroupDetailForFirebase["Created"] = newGroup.groupDetail.groupCreationDate
        newGroupDetailForFirebase["Host"] = newGroup.groupDetail.groupHost
        newGroupDetailForFirebase["Likes"] = newGroup.groupDetail.groupLikes
        newGroupDetailForFirebase["Status"] = newGroup.groupDetail.groupStatus
    }
}
