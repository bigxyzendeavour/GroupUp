//
//  SearchResultCell.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-04-30.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit
import Firebase

class SearchResultCell: UITableViewCell {

    @IBOutlet weak var groupDisplayImage: UIImageView!
    @IBOutlet weak var groupTitleLabel: UILabel!
    @IBOutlet weak var groupDetailLabel: UILabel!
    @IBOutlet weak var groupLocationLabel: UILabel!
    @IBOutlet weak var groupCreationDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(group: Group) {
        groupDisplayImage.image = group.groupDetail.groupDisplayImage
//        let groupDisplayURL = group.groupDetail.groupDisplayImageURL
//        let groupDisplayPhotoRef = Storage.storage().reference(forURL: groupDisplayURL)
//        groupDisplayPhotoRef.getData(maxSize: 1024 * 1024) { (data, error) in
//            if error != nil {
//                print("Photo: Error - \(error?.localizedDescription)")
//            } else {
//                let image = UIImage(data: data!)
//                self.groupDisplayImage.image = image
//            }
//        }
        groupTitleLabel.text = group.groupDetail.groupTitle
        groupDetailLabel.text = group.groupDetail.groupDetailDescription
        groupLocationLabel.text = group.groupDetail.groupMeetUpAddress.city
        let daysPassed = calculateInterval(group: group)
        assignPostDateLbl(daysPassed: Int(daysPassed), group: group)
    }
    
    func calculateInterval(group: Group) -> Double {
        let currentDate = NSDate() as Date
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm"
        let creationDate = df.date(from: group.groupDetail.groupCreationDate)!
        let dayDiff = NSDate().calculateIntervalBetweenDates(newDate: creationDate, compareDate: currentDate)
        return dayDiff
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
