//
//  PreviousPhotoOpenVC.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-04-27.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit

class PreviousPhotoOpenVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var selectedGroup: Group!
    var selectedImageIndex: IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        photoCollectionView.isPagingEnabled = true
        pageControl.numberOfPages = selectedGroup.groupPhotos.count
        
        let layout = photoCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
        
        if selectedImageIndex != nil {
            pageControl.currentPage = selectedImageIndex.item
            photoCollectionView.scrollToItem(at: selectedImageIndex, at: .centeredHorizontally, animated: false)
        }
        
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedGroup.groupPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = photoCollectionView.dequeueReusableCell(withReuseIdentifier: "NearbyGroupPreviousPhotoOpenCollectionCell", for: indexPath) as! NearbyGroupPreviousPhotoOpenCollectionCell
        let image = selectedGroup.groupPhotos[indexPath.row].photo
        cell.configureCell(image: image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: self.view.frame.height)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        pageControl.currentPage = Int(x / self.view.frame.width)
        let layout = photoCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 0
    }
}
