//
//  NearbyGroupDetailHostCell.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-07-10.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit
import Firebase

protocol NearbyGroupDetailHostCellDelegate {
    func setHostImage(hostDisplay: UIImage)
    func setHostName(hostName: String)
}

class NearbyGroupDetailHostCell: UITableViewCell {
    
    @IBOutlet weak var hostDisplayImage: UIImageView!
    @IBOutlet weak var hostNameLabel: UILabel!

    var delegate: NearbyGroupDetailHostCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        hostDisplayImage.heightCircleView()
    }
    
    func configureCell(group: Group) {
        let groupHostID = group.groupDetail.groupHost
        DataService.ds.STORAGE_USER_IMAGE.child("\(groupHostID).jpg").getData(maxSize: 1024 * 1024) { (data, error) in
            if error != nil {
                print("GroupUp: \(error?.localizedDescription)")
            } else {
                let image = UIImage(data: data!)
                self.hostDisplayImage.image = image!
                if let delegate = self.delegate {
                    delegate.setHostImage(hostDisplay: image!)
                }
            }
        }
        
        DataService.ds.REF_USERS.child(groupHostID).child("Username").observeSingleEvent(of: .value, with: { (snapshot) in
            if let hostName = snapshot.value as? String {
                self.hostNameLabel.text = hostName
                if let delegate = self.delegate {
                    delegate.setHostName(hostName: hostName)
                }
            }
        })    
        
    }
}
