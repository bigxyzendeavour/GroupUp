//
//  DataService.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-04-18.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

let DB_BASE = Database.database().reference()
let STORAGE_BASE = Storage.storage().reference()

class DataService {
    
    static let ds = DataService()
    var uid = Auth.auth().currentUser?.uid
    
    //DB references
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("Users")
    private var _REF_GROUPS = DB_BASE.child("Groups")
    private var _REF_FEEDBACKS = DB_BASE.child("Feedbacks")
    private var _REF_DEFECTS = DB_BASE.child("Defects")
    
    //STORAGE references
    private var _STORAGE_USER_IMAGE = STORAGE_BASE.child("Users")
    private var _STORAGE_GROUP_IMAGE = STORAGE_BASE.child("All Groups")
    private var _STORAGE_DEFECT_IMAGE = STORAGE_BASE.child("Defects")
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    var REF_USERS_CURRENT: DatabaseReference {
        let currentUser = DataService.ds._REF_USERS.child(uid!)
        return currentUser
    }
    
    var REF_GROUPS: DatabaseReference {
        return _REF_GROUPS
    }
    
    var REF_USERS_CURRENT_LIKE: DatabaseReference {
        return REF_USERS_CURRENT.child("Likes")
    }
    
    var REF_USERS_CURRENT_FOLLOW: DatabaseReference {
        return REF_USERS_CURRENT.child("Follow")
    }
    
    var REF_USERS_CURRENT_ATTENDING: DatabaseReference {
        return REF_USERS_CURRENT.child("Attending")
    }
    
    var REF_USERS_CURRENT_JOINED: DatabaseReference {
        return REF_USERS_CURRENT.child("Joined")
    }
    
    var REF_USERS_CURRENT_HOSTING: DatabaseReference {
        return REF_USERS_CURRENT.child("Hosting")
    }
    
    var REF_USERS_CURRENT_HOSTED: DatabaseReference {
        return REF_USERS_CURRENT.child("Hosted")
    }
    
    var REF_FEEDBACKS: DatabaseReference {
        return _REF_FEEDBACKS
    }
    
    var REF_DEFECTS: DatabaseReference {
        return _REF_DEFECTS
    }
    
    var STORAGE_USER_IMAGE: StorageReference {
        return _STORAGE_USER_IMAGE
    }
    
    var STORAGE_GROUP_IMAGE: StorageReference {
        return _STORAGE_GROUP_IMAGE
    }
    
    var STORAGE_DEFECT_IMAGE: StorageReference {
        return _STORAGE_DEFECT_IMAGE
    }
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, Any>) {
        REF_USERS.child(uid).updateChildValues(userData)
        
    }
}
