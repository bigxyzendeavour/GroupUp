//
//  SavedCategoryCell.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-05-03.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit
import  Firebase

class SavedCategoryCell: UITableViewCell {
    
    @IBOutlet weak var groupDisplayImageView: UIImageView!
    @IBOutlet weak var groupTitleLabel: UILabel!
    @IBOutlet weak var groupDescriptionLabel: UILabel!
    @IBOutlet weak var groupLocationLabel: UILabel!
    @IBOutlet weak var groupCreationDateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(group: Group) {
//        if group.groupDetail.groupDisplayImageURL != "" {
//            let groupDisplayURL = group.groupDetail.groupDisplayImageURL
//            let groupDisplayPhotoRef = Storage.storage().reference(forURL: groupDisplayURL)
//            groupDisplayPhotoRef.getData(maxSize: 1024 * 1024) { (data, error) in
//                if error != nil {
//                    print("Photo: Error - \(error?.localizedDescription)")
//                } else {
//                    let image = UIImage(data: data!)
//                    self.groupDisplayImageView.image = image
//                }
//            }
//        }
//        let groupID = group.groupID
//        DataService.ds.STORAGE_GROUP_IMAGE.child(groupID).child("Display").getData(maxSize: 1024 * 1024) { (data, error) in
//            if error != nil {
//                print("\(error?.localizedDescription)")
//            } else {
//                let image = UIImage(data: data!)
//                self.groupDisplayImageView.image = image!
//                MySavedGroupVC.imageCache.setObject(image!, forKey: group.groupDetail.groupDisplayImageURL as NSString)
//            }
//        }
        groupDisplayImageView.image = group.groupDetail.groupDisplayImage
        groupTitleLabel.text = group.groupDetail.groupTitle
        groupDescriptionLabel.text = group.groupDetail.groupDetailDescription
        groupLocationLabel.text = group.groupDetail.groupMeetUpAddress.city
        let daysPassed = calculateInterval(group: group)
        assignPostDateLbl(daysPassed: daysPassed, group: group)
    }
    
    func calculateInterval(group: Group) -> Int {
        let currentDate = NSDate()
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm"
        let date = df.date(from: group.groupDetail.groupCreationDate)!
        let interval = currentDate.timeIntervalSince(date as Date)
        return Int(interval) / 259200
    }
    
    func assignPostDateLbl(daysPassed: Int, group: Group) {
        if  daysPassed > 3 {
            self.groupCreationDateLabel.text = "\(daysPassed)ds ago"
        } else {
            let date = group.groupDetail.groupCreationDate
            let index = date.index(date.startIndex, offsetBy: 10)
            let shortDate = date.substring(to: index)
            self.groupCreationDateLabel.text = "\(shortDate)"
        }
    }
}
