//
//  NearbyGroupPreviousPhotoCell.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-04-16.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit

class NearbyGroupPreviousPhotoCell: UITableViewCell {
    
    @IBOutlet private weak var previousPhotoCollectionView: UICollectionView!
    

    override func awakeFromNib() {
        super.awakeFromNib()

        let previousPhotoCollectionViewLayout = previousPhotoCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        previousPhotoCollectionViewLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        previousPhotoCollectionViewLayout.minimumInteritemSpacing = 0
        previousPhotoCollectionViewLayout.itemSize = CGSize(width: (previousPhotoCollectionView.frame.width - 20)/3, height: (previousPhotoCollectionView.frame.width - 20)/3)
    }

//    func configureCell(group: Group) {
//        if group.groupPhotos.count != 0 {
//           
//            
//            
//        }
//    }
    
    func setCollectionViewDataSourceDelegate
        <D: UICollectionViewDataSource & UICollectionViewDelegate>
        (dataSourceDelegate: D, forRow row: Int) {
        
        previousPhotoCollectionView.delegate = dataSourceDelegate
        previousPhotoCollectionView.dataSource = dataSourceDelegate
        previousPhotoCollectionView.reloadData()
    }
}
