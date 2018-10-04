//
//  NewGroupPreviousPhotoCell.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-05-13.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit

protocol NewGroupPreviousPhotoCellDelegate {
    func resetPreviousPhotos()
}

//May not need it

class NewGroupPreviousPhotoCell: UITableViewCell {
    
    @IBOutlet weak var newGroupPreviousPhotoCollectionView: UICollectionView!
    
    var delegate: NewGroupPreviousPhotoCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
   
    }
    
    @IBAction func cancelBtnPressed(_ sender: UIButton) {
        delegate?.resetPreviousPhotos()
    }
    

    func setCollectionViewDataSourceDelegate
        <D: UICollectionViewDataSource & UICollectionViewDelegate>
        (dataSourceDelegate: D, forRow row: Int) {
        
        newGroupPreviousPhotoCollectionView.delegate = dataSourceDelegate
        newGroupPreviousPhotoCollectionView.dataSource = dataSourceDelegate
        newGroupPreviousPhotoCollectionView.reloadData()
    }
    

}
