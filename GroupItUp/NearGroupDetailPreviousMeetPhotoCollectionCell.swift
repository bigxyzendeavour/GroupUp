//
//  NearbyGroupDetailPreviousMeetPhotoCollectionCell.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-04-16.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit
import Firebase

class NearbyGroupDetailPreviousMeetPhotoCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var groupPhotoImage: UIImageView!
    
    
    func configureCell(image: UIImage) {
//        let url = photo.photoURL
//        Storage.storage().reference(forURL: url).getData(maxSize: 1024 * 1024) { (data, error) in
//            if error != nil {
//                print("NearbyGroupDetailPreviousMeetPhotoCollectionCell: \(error?.localizedDescription)")
//            } else {
//                let image = UIImage(data: data!)
//                self.groupPhotoImage.image = image
//            }
//        }
        groupPhotoImage.image = image
    }
    
    func setCollectionViewDataSourceDelegate
        <D: UICollectionViewDataSource & UICollectionViewDelegate>
        (dataSourceDelegate: D, forRow row: Int) {
        
//        previousPhotoCollectionView.delegate = dataSourceDelegate
//        previousPhotoCollectionView.dataSource = dataSourceDelegate
//        previousPhotoCollectionView.reloadData()
    }
}
