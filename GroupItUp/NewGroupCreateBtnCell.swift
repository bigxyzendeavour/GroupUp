//
//  NewGroupCreateBtnCell.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-05-06.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase

protocol NewGroupCreateBtnCellDelegate {
    func getGroupTitle() -> String
    func getGroupDisplayImage() -> UIImage
    func getGroupDescription() -> String
    func getGroupDetail() -> Dictionary<String, Any>
    func getGroupMeetingAddress() -> Dictionary<String, Any>
    func getPreviousGroupPhotos() -> [UIImage]
    func sendAlertWithoutHandler(alertTitle: String, alertMessage: String, actionTitle: [String])
    func sendAlertWithHandler(alertTitle: String, alertMessage: String, actionTitle: [String], handlers:[(_ action: UIAlertAction) -> Void])
    func performSegue(withIdentifier: String, sender: Any?)
    func setSelectedGroup(group: Group)
    func getGroupAddressForGroup() -> Address
    func startActivityIndicator()
    func stopActivityIndicator()
}

class NewGroupCreateBtnCell: UITableViewCell {
    
    @IBOutlet weak var createGroupButton: UIButton!
    
    
    var delegate: NewGroupCreateBtnCellDelegate?
//    var groupDetail: Dictionary<String, Any>!
    let stringArray = ["Max Attending Members", "Time", "Contact", "Phone", "Email", "Address", "Category"]
    var allowEmptyGroupDisplayImage: Bool = false
    var continueWithoutAccurateAddress: Bool = false
    var groupDetail: GroupDetail!
    var currentGroup: Group!
    var groupCreationCompleted = false

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func createGroupBtnPressed(_ sender: UIButton) {
        if let delegate = self.delegate {
            
            sender.isEnabled = false
            self.getDelegate().startActivityIndicator()
            var currentDetailForFirebase = delegate.getGroupDetail()
            currentGroup = getCurrentGroup()
            groupDetail = GroupDetail(new: true)

            if currentDetailForFirebase.count != 6 {
                delegate.sendAlertWithoutHandler(alertTitle: "Missing Information", alertMessage: "Something is missing. Please fill in all the information for the Detail section", actionTitle: ["Cancel"])
                sender.isEnabled = true
                self.getDelegate().stopActivityIndicator()
                return
            } else {
                groupDetail.groupCategory = currentDetailForFirebase["Category"] as! String
                groupDetail.groupContact = currentDetailForFirebase["Contact"] as! String
                groupDetail.groupContactEmail = currentDetailForFirebase["Email"] as! String
                groupDetail.groupContactPhone = currentDetailForFirebase["Phone"] as! String
                groupDetail.groupMaxMembers = currentDetailForFirebase["Max Attending Members"] as! Int
                groupDetail.groupMeetingTime = currentDetailForFirebase["Time"] as! String
            }
            
            if delegate.getGroupTitle() == "" {
                delegate.sendAlertWithoutHandler(alertTitle: "Missing Title", alertMessage: "Please give a title to your group event", actionTitle: ["Cancel"])
                sender.isEnabled = true
                self.getDelegate().stopActivityIndicator()
                return
            } else {
                currentDetailForFirebase["Title"] = delegate.getGroupTitle()
                groupDetail.groupTitle = currentDetailForFirebase["Title"] as! String
            }
            
            if delegate.getGroupDescription() == "" {
                delegate.sendAlertWithoutHandler(alertTitle: "Error", alertMessage: "Please give a description to your group event", actionTitle: ["Cancel"])
                sender.isEnabled = true
                self.getDelegate().stopActivityIndicator()
                return
            } else {
                currentDetailForFirebase["Detail Description"] = delegate.getGroupDescription()
                groupDetail.groupDetailDescription = currentDetailForFirebase["Detail Description"] as! String
            }
            
            if delegate.getGroupMeetingAddress().isEmpty {
                delegate.sendAlertWithoutHandler(alertTitle: "Incorrect Address", alertMessage: "Please provice an accurate address where the group members will meet up.", actionTitle: ["Cancel"])
                sender.isEnabled = true
                self.getDelegate().stopActivityIndicator()
                return
            } else {
                currentDetailForFirebase["Address"] = delegate.getGroupMeetingAddress()
                groupDetail.groupMeetUpAddress = delegate.getGroupAddressForGroup()
            }
            
            delegate.startActivityIndicator()
            //Local Group
            updateGroupDetail(detail: groupDetail)
            currentGroup.groupDetail = getCurrentDetail()
            updateCurrentGroup(group: currentGroup)
            
            DataService.ds.REF_GROUPS.observeSingleEvent(of: .value, with: { (snapshot) -> Void in
                if let snapShot = snapshot.children.allObjects as? [DataSnapshot] {
                    let groupDetailForFirebase = self.addInitGroupDetail(currentDetail: currentDetailForFirebase)
                    var groupID: String
                    let count = snapShot.count
                    groupID = self.createGroupID(count: count)
                    let currentGroup = self.getCurrentGroup()
                    currentGroup.groupID = groupID
                    currentGroup.groupDetail.groupID = groupID
                    self.updateCurrentGroup(group: currentGroup)
                    self.processGroupPhotos(groupID: groupID, groupDetailForFirebase: groupDetailForFirebase)
                    self.getDelegate().stopActivityIndicator()
                    
                }
            })
        }
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
    
    func processGroupPhotos(groupID: String, groupDetailForFirebase: Dictionary<String, Any>) {
        
        var groupData = [String: Any]()
        var detailForFirebase = groupDetailForFirebase
        let currentDetail = self.getCurrentDetail()
        if getDelegate().getGroupDisplayImage() == UIImage(named: "emptyImage") {
            let yesActionHandler = {(action: UIAlertAction) -> Void in
                self.getDelegate().startActivityIndicator()
                let imageID = "Display.jpg"
                let imageData = UIImageJPEGRepresentation(self.getDelegate().getGroupDisplayImage(), 0.25)
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpeg"
                DataService.ds.STORAGE_GROUP_IMAGE.child(groupID).child(imageID).putData(imageData!, metadata: metadata, completion: { (metadata, error) in
                    if error != nil {
                        self.getDelegate().sendAlertWithoutHandler(alertTitle: "Error", alertMessage: "\(error!.localizedDescription)", actionTitle: ["Cancel"])
                        self.createGroupButton.isEnabled = true
                        self.getDelegate().stopActivityIndicator()
                    } else {
                        let url = metadata?.downloadURL()?.absoluteString
                        detailForFirebase["Group Display Photo URL"] = url
                        groupData = ["Group Detail": detailForFirebase]
                        DataService.ds.REF_GROUPS.child(groupID).updateChildValues(groupData)
                        
                        //Update current Group object
                        currentDetail.groupDisplayImageURL = url!
                        currentDetail.groupDisplayImage = UIImage(named: "emptyImage")!
                        self.updateGroupDetail(detail: currentDetail)
                        
                        let groupToBeDisplayed = self.getCurrentGroup()
                        groupToBeDisplayed.groupDetail.groupDisplayImage = self.getDelegate().getGroupDisplayImage()
                        var groupPreviousPhotos = [Photo]()
                        for eachImage in self.getDelegate().getPreviousGroupPhotos() {
                            let photo = Photo()
                            photo.photo = eachImage
                            groupPreviousPhotos.append(photo)
                        }
                        groupToBeDisplayed.groupPhotos = groupPreviousPhotos
                        self.getDelegate().setSelectedGroup(group: groupToBeDisplayed)
                        self.getDelegate().performSegue(withIdentifier: "NewGroupCreationCompletedVC", sender: nil)
                        self.getDelegate().stopActivityIndicator()
                    }
                })
            }
            let cancelActionHandler = {(action: UIAlertAction) -> Void in
                self.createGroupButton.isEnabled = true
                self.getDelegate().stopActivityIndicator()
                return
            }
            getDelegate().sendAlertWithHandler(alertTitle: "Missing Display Image", alertMessage: "The group event doesn't have a display image, are you sure to continue? You can add one later on.", actionTitle: ["Yes", "Cancel"], handlers: [yesActionHandler, cancelActionHandler])
        } else {
            self.getDelegate().startActivityIndicator()
            let image = getDelegate().getGroupDisplayImage()
            let imageID = "Display.jpg"
            let imageData = UIImageJPEGRepresentation(image, 0.5)
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            DataService.ds.STORAGE_GROUP_IMAGE.child(groupID).child(imageID).putData(imageData!, metadata: metadata, completion: { (metadata, error) in
                if error != nil {
                    self.getDelegate().sendAlertWithoutHandler(alertTitle: "Error", alertMessage: "\(error!.localizedDescription)", actionTitle: ["Cancel"])
                } else {
                    let url = metadata?.downloadURL()?.absoluteString
                    detailForFirebase["Group Display Photo URL"] = url
                    groupData = ["Group Detail": detailForFirebase]
                    DataService.ds.REF_GROUPS.child(groupID).updateChildValues(groupData)
                    
                    currentDetail.groupDisplayImage = image
                    currentDetail.groupDisplayImageURL = url!
                    self.updateGroupDetail(detail: currentDetail)
                    
                    let groupToBeDisplayed = self.getCurrentGroup()
                    groupToBeDisplayed.groupDetail.groupDisplayImage = self.getDelegate().getGroupDisplayImage()
                    var groupPreviousPhotos = [Photo]()
                    for eachImage in self.getDelegate().getPreviousGroupPhotos() {
                        let photo = Photo()
                        photo.photo = eachImage
                        groupPreviousPhotos.append(photo)
                    }
                    groupToBeDisplayed.groupPhotos = groupPreviousPhotos
                    self.getDelegate().setSelectedGroup(group: groupToBeDisplayed)
                   
                }
            })
            

        }
        
        DataService.ds.REF_USERS_CURRENT.child("Attending").child(groupID).setValue(true)
        DataService.ds.REF_USERS_CURRENT.child("Hosting").child(groupID).setValue(true)
        
        if !getDelegate().getPreviousGroupPhotos().isEmpty {
            let currentGroup = self.getCurrentGroup()
            var currentGroupPhotos = currentGroup.groupPhotos
            
            let allPreviousPhotos = getDelegate().getPreviousGroupPhotos()
            for i in 0..<allPreviousPhotos.count {
                let image = allPreviousPhotos[i]
                let imageData = UIImageJPEGRepresentation(image, 0.5)
                var imageUid: String
                if i < 9 {
                    imageUid = "0\(i + 1)"
                } else {
                    imageUid = "\(i + 1)"
                }
                
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpeg"
                DataService.ds.STORAGE_GROUP_IMAGE.child(groupID).child("\(imageUid).jpg").putData(imageData!, metadata: metadata, completion: { (metadata, error) in
                    if error != nil {
                        self.getDelegate().sendAlertWithoutHandler(alertTitle: "Error", alertMessage: "\(error!.localizedDescription)", actionTitle: ["Cancel"])
                        
                    } else {
                        let url = metadata?.downloadURL()?.absoluteString
                        DataService.ds.REF_GROUPS.child(groupID).child("Previous Photos").child(imageUid).setValue(url)
                        let photo = Photo(photoID: imageUid, photoURL: url!)
                        currentGroupPhotos.append(photo)
                        self.getDelegate().performSegue(withIdentifier: "NewGroupCreationCompletedVC", sender: nil)
                        self.groupCreationCompleted = true
                    }
                })
            }
            currentGroup.groupPhotos = currentGroupPhotos
            self.updateCurrentGroup(group: currentGroup)
        }
        
    }
    
    func addInitGroupDetail(currentDetail: Dictionary<String, Any>) -> Dictionary<String, Any> {
        var detail = currentDetail
        detail["Created"] = "\(NSDate().fullTimeCreated())"
        detail["Host"] = currentUser.userID
        detail["Attending"] = 1
        detail["Likes"] = 0
        detail["Status"] = "Planning"
        detail["Attending Users"] = [currentUser.userID: true]
        return detail
    }
    
    func getDelegate() -> NewGroupCreateBtnCellDelegate {
        return delegate!
    }
    
    func updateGroupDetail(detail: GroupDetail) {
        groupDetail = detail
    }
    
    func getCurrentDetail() -> GroupDetail {
        if groupDetail != nil {
            return groupDetail
        } else {
            groupDetail = GroupDetail()
            return groupDetail
        }
    }
    
    func getCurrentGroup() -> Group {
        if currentGroup != nil {
            return currentGroup
        } else {
            currentGroup = Group()
            return currentGroup
        }
    }
    
    func updateCurrentGroup(group: Group) {
        currentGroup = group
    }
}
