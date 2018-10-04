//
//  Comment.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-04-20.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class Comment {
    
    private var _commentID: String!
    private var _userID: String!
    private var _username: String!
    private var _comment: String!
    private var _userDisplayImage: UIImage?
    
    init() {
        self._commentID = ""
        self._username = ""
        self._userID = ""
        self._comment = ""
        self._userDisplayImage = UIImage()
    }
    
    //Initiate a comment to be sent, no commentID yet, this is set when initiating a comment
    init(id: String) {
        self._commentID = ""
        self._userID = id
        
    }
    
    //Download data
    init(commentID: String, commentData: Dictionary<String, Any>) {
        self._commentID = commentID
        let userID = commentData["User ID"] as! String
        self._userID = userID

        DataService.ds.STORAGE_USER_IMAGE.child("\(userID).jpg").getData(maxSize: 1024 * 1024) { (data, error) in
            if error != nil {
                print("Comment(2): Error - \(error?.localizedDescription)")
            } else {
                let image = UIImage(data: data!)
                self._userDisplayImage = image
            }
        }
        let comment = commentData["Comment"] as! String
        self._comment = comment
        
        DataService.ds.REF_USERS.child(userID).child("Username").observeSingleEvent(of: .value, with: { (snapshot) in
            if let commentUser = snapshot.value as? String {
                self._username = commentUser
            }
        })
    }
    
    var commentID: String {
        get {
            return _commentID
        }
        set {
            _commentID = newValue
        }
    }
    
    var userID: String {
        get {
            return _userID
        }
        set {
            _userID = newValue
        }
    }
    
    var username: String {
        get {
            return _username
        }
        set {
            _username = newValue
        }
    }
    
    var comment: String {
        get {
            if _comment != nil {
                return _comment
            } else {
                _comment = ""
                return _comment
            }
        }
        set {
            _comment = newValue
        }
    }
    
    var userDisplayImage: UIImage {
        get {
            if _userDisplayImage != nil {
                return _userDisplayImage!
            } else {
                _userDisplayImage = UIImage()
                return _userDisplayImage!
            }
            
        }
        set {
            _userDisplayImage = newValue
        }
    }
}
