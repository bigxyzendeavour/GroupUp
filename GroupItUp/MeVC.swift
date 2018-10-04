//
//  MeVC.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-04-12.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class MeVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, EditProfileVCDelegate {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userDisplayImageView: UIImageView!
    @IBOutlet weak var userCollectionView: UICollectionView!
    @IBOutlet weak var userDataCollectionView: UICollectionView!
    
    let savedCategory = ["Likes", "Follow", "Attending", "Joined", "Hosting", "Hosted"]
    let userDataCollection = ["Fans", "Following", "Hosted"]
    var selectedSavedOption: String!
    var fromNewGroupCreationCompleteVC = false
    var fansNumber: Int = 0
    var followNumber: Int = 0
    var hostedNumber: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userCollectionView.delegate = self
        userCollectionView.dataSource = self
        
        userDataCollectionView.delegate = self
        userDataCollectionView.dataSource = self
        
        userDisplayImageView.heightCircleView()
    
        let userCollectionLayout = userCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        userCollectionLayout.sectionInset = UIEdgeInsetsMake(0, 0, -10, 0)
        userCollectionLayout.minimumInteritemSpacing = 0
        userCollectionLayout.itemSize = CGSize(width: (self.view.frame.width - 50)/3, height: (userCollectionView.frame.height - 20)/2)
        
        let userDataCollectionLayout = userDataCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        userDataCollectionLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        userDataCollectionLayout.minimumInteritemSpacing = 0
        userDataCollectionLayout.itemSize = CGSize(width: (self.view.frame.width - 30)/3, height: userDataCollectionView.frame.height - 10)
        
        navigationController?.navigationBar.shadowImage = UIImage()
        initialize()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if fromNewGroupCreationCompleteVC == true {
            self.navigationItem.hidesBackButton = true
            self.tabBarController?.tabBar.isHidden = false
            fromNewGroupCreationCompleteVC = false
        }
        refreshUserStat()
    }
    
    func initialize() {
        usernameLabel.text = currentUser.username
        userDisplayImageView.image = currentUser.userDisplayImage
    }
    
    func refreshUserStat() {
        DataService.ds.REF_USERS_CURRENT.child("Fans").observeSingleEvent(of: .value, with: { (snapshot) in
            let snapCount = snapshot.children.allObjects.count
            self.fansNumber = snapCount
            self.userDataCollectionView.reloadData()
        })
        
        DataService.ds.REF_USERS_CURRENT.child("Follow").observeSingleEvent(of: .value, with: { (snapshot) in
            let snapCount = snapshot.children.allObjects.count
            self.followNumber = snapCount
            self.userDataCollectionView.reloadData()
        })
        
        DataService.ds.REF_USERS_CURRENT.child("Hosted").observeSingleEvent(of: .value, with: { (snapshot) in
            let snapCount = snapshot.children.allObjects.count
            self.hostedNumber = snapCount
            self.userDataCollectionView.reloadData()
        })
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.isEqual(userDataCollectionView) {
            return 3
        } else {
            return 6
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.isEqual(userDataCollectionView) {
            let userDataName = userDataCollection[indexPath.item]
            var userDataNumber = 0
            if userDataName == "Fans" {
                userDataNumber = fansNumber
            } else if userDataName == "Following" {
                userDataNumber = followNumber
            } else if userDataName == "Hosted" {
                userDataNumber = hostedNumber
            }
            
            let cell = userDataCollectionView.dequeueReusableCell(withReuseIdentifier: "userDataCollectionCell", for: indexPath) as! userDataCollectionCell
            cell.configureCell(name: userDataName, number: userDataNumber)
            return cell
        } else {
            let category = savedCategory[indexPath.item]
            let cell = userCollectionView.dequeueReusableCell(withReuseIdentifier: "UserSavedGroupCollectionCell", for: indexPath) as! UserSavedGroupCollectionCell
            cell.configureCell(category: category)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedSavedOption = savedCategory[indexPath.item]
        if collectionView.isEqual(userCollectionView) {
            if selectedSavedOption != "Follow" {
                performSegue(withIdentifier: "MySavedGroupVC", sender: nil)
            } else {
                performSegue(withIdentifier: "MyFollowUserVC", sender: nil)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? MySavedGroupVC {
            destination.selectedSavedOption = selectedSavedOption
        }
        if let destination = segue.destination as? EditProfileVC {
            destination.delegate = self
            let displayImage = userDisplayImageView.image!
            destination.displayImage = displayImage
        }
    }
    
    @IBAction func editBtnPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController()
        
        let editProfileHanlder = {(action: UIAlertAction!) -> Void in
            self.performSegue(withIdentifier: "EditProfileVC", sender: nil)
        }
        
        let createNewGroupHandler = {(action: UIAlertAction!) -> Void in
            newGroup = Group()
            newGroupForFirebase = [String: Any]()
            self.performSegue(withIdentifier: "NewGroupCreationVC", sender: nil)
        }
        
        alert.addAction(UIAlertAction(title: "Edit Profile", style: .default, handler: editProfileHanlder))
        alert.addAction(UIAlertAction(title: "Create a New Group", style: .default, handler: createNewGroupHandler))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func updateProfileDisplayImageFromEditProfileVC(image: UIImage) {
        userDisplayImageView.image = image
    }
    
    func updateUsernameFromEditProfileVC(newName: String) {
        usernameLabel.text = newName
    }
}
