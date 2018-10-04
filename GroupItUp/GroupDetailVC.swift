//
//  GroupDetailVC.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-04-15.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit
import Firebase

class GroupDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, NearbyGroupCommentEntryCellDelegate, NearbyGroupDetailCellDelegate, SettingVCDelegate, NearbyGroupDetailHostCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var actionBtn: UIBarButtonItem!

    var newCreatedGroup: Bool = false
    var selectedGroup: Group!
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var groupDisplay: UIImage!
    var hostDisplayImage: UIImage!
    var hostName: String!
    var selectedImageIndex: IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        if newCreatedGroup == true {
            self.navigationItem.hidesBackButton = true
        }
        
        if selectedGroup.groupDetail.groupHost != currentUser.userID {
            actionBtn.isEnabled = false
        }
        
        if selectedGroup.groupDetail.groupStatus != "Planning" {
            sendAlertWithoutHandler(alertTitle: "Inactive", alertMessage: "This group has been closed!", actionTitle: ["Cancel"])
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if selectedGroup.groupPhotos.count > 0 {
            return selectedGroup.groupPhotos.count
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NearbyGroupDetailPreviousMeetPhotoCollectionCell", for: indexPath) as? NearbyGroupDetailPreviousMeetPhotoCollectionCell {
            var photo = Photo()
            if selectedGroup.groupPhotos.count > 0 {
                photo = selectedGroup.groupPhotos[indexPath.item]
                if photo.photo != UIImage() {
                    cell.configureCell(image: photo.photo)
                } else {
                    let url = photo.photoURL
                    Storage.storage().reference(forURL: url).getData(maxSize: 1024 * 1024) { (data, error) in
                        if error != nil {
                            print("NearbyGroupDetailPreviousMeetPhotoCollectionCell: \(error?.localizedDescription)")
                        } else {
                            let image = UIImage(data: data!)
                            cell.configureCell(image: image!)
                            self.selectedGroup.groupPhotos[indexPath.row].photo = image!
                        }
                    }
                }
            }
            cell.groupPhotoImage.isUserInteractionEnabled = true
            return cell
        }
        
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: false)
        selectedImageIndex = indexPath
        performSegue(withIdentifier: "PreviousPhotoOpenVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PreviousPhotoOpenVC {
            destination.selectedGroup = selectedGroup
            destination.selectedImageIndex = selectedImageIndex
        }
        if let destination = segue.destination as? SettingVC {
            destination.currentGroup = selectedGroup
            destination.delegate = self
        }
        if let destination = segue.destination as? HostVC {
            
            let host = Host()
            host.userID = selectedGroup.groupDetail.groupHost
            if hostName != nil {
                host.username = hostName
            }
            if hostDisplayImage != nil {
                host.userDisplayImage = hostDisplayImage
            }
            destination.host = host
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 4 {
            if selectedGroup.groupPhotos.count > 0 {
                return 1
            } else {
                return 0
            }
        }
        if section == 5 {
            if selectedGroup.groupComments.count > 0 {
                return selectedGroup.groupComments.count
            } else {
                return 0
            }
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NearbyGroupDisplayPhotoCell") as! NearbyGroupDisplayPhotoCell
            if selectedGroup.groupDetail.groupDisplayImage != UIImage() {
                cell.configureCell(group: selectedGroup, image: selectedGroup.groupDetail.groupDisplayImage)
            } else if let image = GroupDetailVC.imageCache.object(forKey: "New Group Display Image" as NSString) {
                cell.configureCell(group: selectedGroup, image: image)
            } else {
                cell.configureCell(group: selectedGroup, image: nil)
            }
            
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NearbyGroupDescriptionCell") as! NearbyGroupDescriptionCell
            cell.setSelectedGroup(group: selectedGroup)
            cell.configureCell(group: selectedGroup)
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NearbyGroupDetailHostCell") as! NearbyGroupDetailHostCell
            cell.delegate =  self
            cell.configureCell(group: selectedGroup)
            return cell
        } else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NearbyGroupDetailCell") as! NearbyGroupDetailCell
            cell.delegate = self
            cell.configureCell(group: selectedGroup)
            return cell
        } else if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NearbyGroupPreviousPhotoCell") as! NearbyGroupPreviousPhotoCell
            cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
            return cell
        } else if indexPath.section == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NearbyGroupDetailCommentCell") as! NearbyGroupDetailCommentCell
            if selectedGroup.groupComments.count > 0 {
                let comment = selectedGroup.groupComments[indexPath.row]
                cell.userDisplayImage.heightCircleView()
                cell.configureCell(comment: comment, group: selectedGroup)
            } 
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NearbyGroupCommentEntryCell") as! NearbyGroupCommentEntryCell
            cell.delegate = self
            cell.setSelectedGroup(group: selectedGroup)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            if selectedGroup.groupDetail.groupHost == currentUser.userID {
                performSegue(withIdentifier: "MeVC", sender: nil)
            } else {
                performSegue(withIdentifier: "HostVC", sender: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2 {
            return 130
        } else {
            return tableView.rowHeight
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section <= 3 {
            //return nothing
            return CGFloat.leastNormalMagnitude
        } else if section == 4 {
            if selectedGroup.groupPhotos.count > 0 {
                return 25
            }
            return CGFloat.leastNormalMagnitude
        } else if section == 5 {
            return 25
        } else {
            return CGFloat.leastNormalMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 4 {
            if selectedGroup.groupPhotos.count > 0 {
                return "Previous Photos"
            }
            return ""
        } else if section == 5 {
            return "Comments"
        } else {
            return ""
        }
    }
    
    func updateComments(comments: [Comment]) {
        selectedGroup.groupComments = comments
    }
    
    func reloadCommentSection() {
        tableView.beginUpdates()
        let indexPath = IndexPath(row: 0, section: 5)
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    @IBAction func actionBtnPressed(_ sender: UIBarButtonItem) {
        if selectedGroup.groupDetail.groupStatus == "Completed" && selectedGroup.groupDetail.groupHost == currentUser.userID {
            sendAlertWithoutHandler(alertTitle: "Group Event Completed", alertMessage: "The group event has been completed. Please leave a comment if necessary. Sorry for inconvenience.", actionTitle: ["OK"])
        } else {
            performSegue(withIdentifier: "SettingVC", sender: nil)
        }
    }
    
    func updateDisplayImageFromSettingVC(image: UIImage) {
        selectedGroup.groupDetail.groupDisplayImage = image
    }
    
    func updateGroupStatus(status: String) {
        selectedGroup.groupDetail.groupStatus = status
    }
    
    //From SettingVC
    func updateGroupDetail(detail: GroupDetail) {
        selectedGroup.groupDetail = detail
    }
    
    func updateGroupAddress(address: Address) {
        selectedGroup.groupDetail.groupMeetUpAddress = address
    }
    
    func updatePreviousGroupPhotos(groupPhotos: [UIImage]) {
        if selectedGroup.groupPhotos.count > 0 {
            for group in selectedGroup.groupPhotos {
                let id = group.photoID
                DataService.ds.REF_GROUPS.child(selectedGroup.groupID).child("Previous Photos").child(id).removeValue()
                DataService.ds.STORAGE_GROUP_IMAGE.child(selectedGroup.groupID).child("\(id).jpg").delete(completion: { (error) in
                    if error != nil {
                        self.sendAlertWithoutHandler(alertTitle: "Error", alertMessage: "\(error!.localizedDescription)", actionTitle: ["Cancel"])
                    }
                })
            }
        }
        selectedGroup.groupPhotos.removeAll()
        for i in 0..<groupPhotos.count {
            var id: String!
            if i + 1 < 10 {
                id = "0\(i + 1)"
            } else {
                id = "\(i + 1)"
            }
            let image = groupPhotos[i]
            let imageData = UIImageJPEGRepresentation(image, 0.5)
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            DataService.ds.STORAGE_GROUP_IMAGE.child(selectedGroup.groupID).child("\(id!).jpg").putData(imageData!, metadata: metadata, completion: { (metadata, error) in
                if error != nil {
                    print("Error: \(error?.localizedDescription)")
                } else {
                    let url = metadata?.downloadURL()?.absoluteString
                    let photo = Photo(photoID: id, photoURL: url!)
                    photo.photo = image
                    self.selectedGroup.groupPhotos.append(photo)
                    DataService.ds.REF_GROUPS.child(self.selectedGroup.groupID).child("Previous Photos").child(id).setValue(url!)
                }
            })
        }
    }
    
    func setHostImage(hostDisplay: UIImage) {
        hostDisplayImage = hostDisplay
    }
    
    func setHostName(hostName: String) {
        self.hostName = hostName
    }
}
