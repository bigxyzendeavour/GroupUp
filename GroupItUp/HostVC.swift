//
//  HostVC.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-07-10.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView

class HostVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable {

    @IBOutlet weak var hostDisplayImage: UIImageView!
    @IBOutlet weak var hostNameLabel: UILabel!
    @IBOutlet weak var hostFansNumberLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var tableView: UITableView!

    var host: Host!
    var searchResults = [Group]()
    var selectedGroup: Group!
    var activityIndicatorView: NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        hostDisplayImage.heightCircleView()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        initialize()
    }

    func initialize() {
        if host.username != "" {
            hostNameLabel.text = host.username
        } else {
            DataService.ds.REF_USERS.child(host.userID).child("Username").observeSingleEvent(of: .value, with: { (snapshot) in
                if let name = snapshot.value as? String {
                    self.host.username = name
                    self.hostNameLabel.text = name
                }
            })
        }
        
        if !host.userDisplayImage.size.equalTo(CGSize.zero) {
            hostDisplayImage.image = host.userDisplayImage
        } else {
            DataService.ds.STORAGE_USER_IMAGE.child("\(host.userID).jpg").getData(maxSize: 1024 * 1024) { (data, error) in
                if error != nil {
                    print("GroupUp: \(error?.localizedDescription)")
                } else {
                    let image = UIImage(data: data!)
                    self.hostDisplayImage.image = image!
                }
            }
        }
        
        DataService.ds.REF_USERS.child(host.userID).child("Fans").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let snapCount = snapshot.childrenCount
            self.hostFansNumberLabel.text = "\(snapCount)"
            if let snapShot = snapshot.value as? Dictionary<String, Bool> {
                if snapShot.keys.contains(currentUser.userID) {
                    self.followButton.backgroundColor = UIColor.green
                    self.followButton.setTitle("Unfollow", for: .normal)
                }
            }
        })
        
        fetchHostPreviousHostedGroups { (groups) in
            self.searchResults = groups
            self.endRefrenshing()
            self.tableView.reloadData()
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? GroupDetailVC {
            destination.selectedGroup = selectedGroup
        }
    }
    
    func fetchHostPreviousHostedGroups(completion: @escaping ([Group]) -> Void) {
        DataService.ds.REF_USERS.child(host.userID).child("Hosted").observeSingleEvent(of: .value, with: { (snapshot) in
            self.startRefreshing()
            if let snapShot = snapshot.children.allObjects as? [DataSnapshot] {
                var keyGroups = [String]()
                var tempGroups = [Group]()
                for snap in snapShot {
                    let key = snap.key
                    keyGroups.insert(key, at: 0)
                }
                
                DataService.ds.REF_GROUPS.observeSingleEvent(of: .value, with: { (snapshot) in
                    if let groupsSnap = snapshot.children.allObjects as? [DataSnapshot] {
                        for snap in groupsSnap {
                            let group = Group()
                            let key = snap.key
                            if keyGroups.contains(key) {
                                var comments = [Comment]()
                                var photos = [Photo]()
                                let groupData = snap.value as! Dictionary<String, Any>
                                let groupDetailData = groupData["Group Detail"] as! Dictionary<String, Any>
                                if let commentData = groupData["Comments"] as? Dictionary<String, Any> {
                                    for eachComment in commentData {
                                        let commentID = eachComment.key
                                        let commentDetail = eachComment.value as! Dictionary<String, Any>
                                        let comment = Comment(commentID: commentID, commentData: commentDetail)
                                        comments.append(comment)
                                    }
                                    group.groupComments = self.orderCommentsByID(comments: comments)
                                }
                                
                                if let previousPhotoData = groupData["Previous Photos"] as? Dictionary<String, String> {
                                    for eachPhoto in previousPhotoData {
                                        let photoID = eachPhoto.key
                                        let photoURL = eachPhoto.value
                                        let photo = Photo(photoID: photoID, photoURL: photoURL)
                                        photos.append(photo)
                                    }
                                    group.groupPhotos = self.orderPhotosByID(photos: photos)
                                }
                                
                                group.groupID = key
                                group.groupDetail = GroupDetail(groupID: key, groupDetailData: groupDetailData)
                                
                                tempGroups.append(group)
                            }
                        }
                        self.searchResults = self.orderGroupsByID(groups: tempGroups)
                        
                        for j in 0..<self.searchResults.count {
                            let group = self.searchResults[j]
                            var photoURLs = [String]()
                            let displayURL = group.groupDetail.groupDisplayImageURL
                            photoURLs.append(displayURL)
                            for photo in group.groupPhotos {
                                let url = photo.photoURL
                                photoURLs.append(url)
                            }
                            
                            for i in 0..<photoURLs.count {
                                let url = photoURLs[i]
                                Storage.storage().reference(forURL: url).getData(maxSize: 1024 * 1024, completion: { (data, error) in
                                    if error != nil {
                                        self.sendAlertWithoutHandler(alertTitle: "Error", alertMessage: "\(error?.localizedDescription)", actionTitle: ["Cancel"])
                                        return
                                    } else {
                                        let image = UIImage(data: data!)
                                        if i == 0 {
                                            group.groupDetail.groupDisplayImage = image!
                                        } else {
                                            group.groupPhotos[i - 1].photo = image!
                                        }
                                        if j == self.searchResults.count - 1 && i == photoURLs.count - 1 {
                                            completion(self.searchResults)
                                        }
                                    }
                                    
                                })
                            }
                        }
                        
                        
                    }
                })
                
            }
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let group = searchResults[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell") as! SearchResultCell
        cell.configureCell(group: group)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let group = searchResults[indexPath.row]
        selectedGroup = group
        performSegue(withIdentifier: "GroupDetailVC", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Previous Hosted Groups"
        } else {
            return ""
        }
    }
    
    @IBAction func followBtnPressed(_ sender: UIButton) {
        let currentFansNumber = Int(hostFansNumberLabel.text!)
        //When pressed
        if followButton.currentTitle == "Follow" {
            followButton.setTitle("Unfollow", for: .normal)
            followButton.backgroundColor = UIColor.green
            hostFansNumberLabel.text = "\(currentFansNumber! + 1)"
            DataService.ds.REF_USERS.child(host.userID).child("Fans").child(currentUser.userID).setValue(true)
            DataService.ds.REF_USERS_CURRENT.child("Follow").child(host.userID).setValue(true)
        } else {
            followButton.setTitle("Follow", for: .normal)
            followButton.backgroundColor = THEME_COLOR
            hostFansNumberLabel.text = "\(currentFansNumber! - 1)"
            DataService.ds.REF_USERS.child(host.userID).child("Fans").child(currentUser.userID).removeValue()
            DataService.ds.REF_USERS_CURRENT.child("Follow").child(host.userID).removeValue()
        }
    }
    
}
