//
//  Photo.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-04-20.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit
import Firebase

class Photo {
    
    private var _photoID: String!
    private var _photoURL: String!
    private var _photo: UIImage?
    
    init() {
        _photoID = ""
        _photoURL = ""
        _photo = UIImage()
    }
    
    init(photoID: String, photoURL: String) {
        self._photoID = photoID
        self._photoURL = photoURL
        Storage.storage().reference(forURL: self._photoURL).getData(maxSize: 1024 * 1024) { (data, error) in
            if error != nil {
                print("\(error?.localizedDescription)")
            } else {
                let image = UIImage(data: data!)
                self._photo = image!
            }
        }
    }
    
    var photoID: String {
        get {
            return _photoID
        }
        set {
            _photoID = newValue
        }
    }
    
    var photoURL: String {
        get {
            return _photoURL
        }
        set {
            _photoURL = newValue
        }
    }
    
    var photo: UIImage {
        get {
            if _photo != nil {
                return _photo!
            } else {
                _photo = UIImage(named: "emptyImage")
                return _photo!
            }
        }
        set {
            _photo = newValue
        }
    }
}
