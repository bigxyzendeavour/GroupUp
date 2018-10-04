//
//  NewGroupCreationCompletedVC.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-05-05.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit
import Firebase

class NewGroupCreationCompletedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, NewGroupCompleteCellDelegate {
    
    @IBOutlet weak var tableview: UITableView!
    
    var newCreatedGroup: Bool = false
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.delegate = self
        tableview.dataSource = self
        
        tableview.estimatedRowHeight = tableview.rowHeight
        tableview.rowHeight = UITableViewAutomaticDimension
        
        if newCreatedGroup == true {
            self.navigationItem.hidesBackButton = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if newGroup.groupPhotos.count > 0 {
            return newGroup.groupPhotos.count
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NearbyGroupDetailPreviousMeetPhotoCollectionCell", for: indexPath) as? NearbyGroupDetailPreviousMeetPhotoCollectionCell {
            let photo = newGroup.groupPhotos[indexPath.row]
            cell.configureCell(image: photo.photo)
            cell.groupPhotoImage.isUserInteractionEnabled = true
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "PreviousPhotoOpenVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PreviousPhotoOpenVC {
            destination.selectedGroup = newGroup
        }
        if let destination = segue.destination as? MeVC {
            destination.fromNewGroupCreationCompleteVC = true
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 3 {
            if newGroup.groupPhotos.count > 0 {
                return 1
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
            cell.configureNewGroupCell(image: newGroup.groupDetail.groupDisplayImage)
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NearbyGroupDescriptionCell") as! NearbyGroupDescriptionCell
            cell.configureNewGroupCell(group: newGroup)
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NearbyGroupDetailCell") as! NearbyGroupDetailCell
            cell.configureNewGroupCell(group: newGroup)
            return cell
        } else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NearbyGroupPreviousPhotoCell") as! NearbyGroupPreviousPhotoCell
            cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewGroupCompleteCell") as! NewGroupCompleteCell
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section <= 2 {
            //return nothing
            return CGFloat.leastNormalMagnitude
        } else if section == 3 {
            if newGroup.groupPhotos.count > 0 {
                return 25
            }
            return CGFloat.leastNormalMagnitude
        } else {
            return CGFloat.leastNormalMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 3 {
            if newGroup.groupPhotos.count > 0 {
                return "Previous Photos"
            }
            return ""
        } else {
            return ""
        }
    }
    
    func completeCreatingGroup() {
        self.performSegue(withIdentifier: "MeVC", sender: nil)
    }
    
    @IBAction func directionBtnPressed(_ sender: UIButton) {
    }
    
}
