//
//  GroupDetail.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-04-20.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit
import Firebase

class GroupDetail {
    
    private var _groupID: String!
    private var _groupDisplayImageURL: String?
    private var _groupDisplayImage: UIImage?
    private var _groupTitle: String!
    private var _groupDetailDescription: String!
    private var _groupCategory: String!
    private var _groupContact: String!
    private var _groupContactEmail: String!
    private var _groupContactPhone: String!
    private var _groupLikes: Int!
    private var _groupAttending: Int!
    private var _groupAttendingUsers: [String: Bool]!
    private var _groupMaxMembers: Int!
    private var _groupMeetingTime: String!
    private var _groupMeetUpAddress: Address!
    private var _groupCreationDate: String!
    private var _groupStatus: String!
    private var _groupHost: String!
    private var _groupMaxReached: Bool!
    
    init() {
        self._groupID = ""
        self._groupDisplayImageURL = ""
        self._groupDisplayImage = UIImage()
        self._groupTitle = ""
        self._groupDetailDescription = ""
        self._groupCategory = ""
        self._groupContact = ""
        self._groupContactEmail = ""
        self._groupContactPhone = ""
        self._groupMaxMembers = 0
        self._groupMeetUpAddress = nil
        self._groupLikes = 0
        self._groupAttending = 1
        self._groupCreationDate = ""
        self._groupStatus = "Planning"
        self._groupHost = currentUser.userID
        self._groupAttendingUsers = [_groupHost: true]
        self._groupMaxReached = false
    }
    
    //Current user creates a new group
    init(new: Bool) {
        if new {
            self._groupHost = currentUser.userID
            self._groupCreationDate = "\(NSDate().fullTimeCreated())"
            self._groupAttending = 1
            self._groupLikes = 0
            self._groupStatus = "Planning"
            self._groupAttendingUsers = [_groupHost: true]
            self._groupMaxReached = false
        }
    }
    
    //Download from Firebase
    init(groupID: String, groupDetailData: Dictionary<String, Any>) {
        self._groupID = groupID
        if let title = groupDetailData["Title"] as? String {
            self._groupTitle = title
        }
        
        if let groupDisplayImageURL = groupDetailData["Group Display Photo URL"] as? String {
            self._groupDisplayImageURL = groupDisplayImageURL
        } else {
            self._groupDisplayImageURL = ""
        }
        
        if let groupCreationDate = groupDetailData["Created"] as? String {
            self._groupCreationDate = groupCreationDate
        }
        
        if let groupStatus = groupDetailData["Status"] as? String {
            self._groupStatus = groupStatus
        }
        
        if let detailDescription = groupDetailData["Detail Description"] as? String {
            self._groupDetailDescription = detailDescription
        }
        
        if let category = groupDetailData["Category"] as? String {
            self._groupCategory = category
        }
        
        if let contact = groupDetailData["Contact"] as? String {
            self._groupContact = contact
        }
        
        if let contactEmail = groupDetailData["Email"] as? String {
            self._groupContactEmail = contactEmail
        }
        
        if let contactPhone = groupDetailData["Phone"] as? String {
            self._groupContactPhone = contactPhone
        }
        
        if let likes = groupDetailData["Likes"] as? Int {
            self._groupLikes = likes
        }
        
        if let attending = groupDetailData["Attending"] as? Int {
            self._groupAttending = attending
        }
        
        if let attendingUsers = groupDetailData["Attending Users"] as? Dictionary<String, Bool> {
            var tempUsers = [String: Bool]()
            for eachAttendingUser in attendingUsers {
                let userID = eachAttendingUser.key
                tempUsers[userID] = true
            }
            self._groupAttendingUsers = tempUsers
        }
        
        if let maxAttendingMembers = groupDetailData["Max Attending Members"] as? Int {
            self._groupMaxMembers = maxAttendingMembers
        }
        
        if let meetingTime = groupDetailData["Time"] as? String {
            self._groupMeetingTime = meetingTime
        }
        
        if let meetUpAddressData = groupDetailData["Address"] as? Dictionary<String, String> {
            var street = ""
            var city = ""
            var province = ""
            var postal = ""
            var country = ""
            if meetUpAddressData["Street"] != nil {
                street = meetUpAddressData["Street"]!
            }
            if meetUpAddressData["City"] != nil {
                city = meetUpAddressData["City"]!
            }
            if meetUpAddressData["Province"] != nil {
                province = meetUpAddressData["Province"]!
            }
            if meetUpAddressData["Postal"] != nil {
                postal = meetUpAddressData["Postal"]!
            }
            if meetUpAddressData["Country"] != nil {
                country = meetUpAddressData["Country"]!
            }
            let address = Address(street: street, city: city, province: province, postal: postal, country: country)
            self._groupMeetUpAddress = address
        } else {
            self._groupMeetUpAddress = Address()
        }
        
        if let groupHost = groupDetailData["Host"] as? String {
            self._groupHost = groupHost
        }
        
        if groupAttending == groupMaxMembers {
            self._groupMaxReached = true
        } else {
            self._groupMaxReached = false
        }
    }
    
    var groupID: String {
        get {
            return _groupID
        }
        set {
            _groupID = newValue
        }
    }
    
    var groupDisplayImageURL: String {
        get {
            if _groupDisplayImageURL != nil {
                return _groupDisplayImageURL!
            } else {
                _groupDisplayImageURL = ""
                return _groupDisplayImageURL!
            }
        }
        set {
            _groupDisplayImageURL = newValue
        }
        
    }
    
    var groupDisplayImage: UIImage {
        get {
            if _groupDisplayImage != nil {
                return _groupDisplayImage!
            } else {
                _groupDisplayImage = UIImage()
                return _groupDisplayImage!
            }
        }
        set {
            _groupDisplayImage = newValue
        }
    }
    
    var groupTitle: String {
        get {
            if _groupTitle == nil {
                _groupTitle = ""
            }
            return _groupTitle
        }
        set {
            _groupTitle = newValue
        }
    }
    
    var groupDetailDescription: String {
        get {
            if _groupDetailDescription == nil {
                _groupDetailDescription = ""
            }
            return _groupDetailDescription
        }
        set {
            _groupDetailDescription = newValue
        }
    }
    
    var groupCategory: String {
        get {
            if _groupCategory == nil {
                _groupCategory = ""
            }
            return _groupCategory
        }
        set {
            _groupCategory = newValue
        }
    }
    
    var groupContact: String {
        get {
            if _groupContact == nil {
                _groupContact = ""
            }
            return _groupContact
        }
        set {
            _groupContact = newValue
        }
    }
    
    var groupContactEmail: String {
        get {
            if _groupContactEmail == nil {
                _groupContactEmail = ""
            }
            return _groupContactEmail
        }
        set {
            _groupContactEmail = newValue
        }
    }
    
    var groupContactPhone: String {
        get {
            if _groupContactPhone == nil {
                _groupContactPhone = ""
            }
            return _groupContactPhone
        }
        set {
            _groupContactPhone = newValue
        }
    }
    
    var groupLikes: Int {
        get {
            return _groupLikes
        }
        set {
            _groupLikes = newValue
        }
    }
    
    var groupAttending: Int {
        get {
            return _groupAttending
        }
        set {
            _groupAttending = newValue
        }
    }
    
    var groupAttendingUsers: [String: Bool] {
        get {
            return _groupAttendingUsers
        }
        set {
            _groupAttendingUsers = newValue
        }
    }
    
    var groupMaxMembers: Int {
        get {
            return _groupMaxMembers
        }
        set {
            _groupMaxMembers = newValue
        }
    }
    
    var groupMeetingTime: String {
        get {
            if _groupMeetingTime == nil {
                _groupMeetingTime = ""
            }
            return _groupMeetingTime
        }
        set {
            _groupMeetingTime = newValue
        }
    }
    
    var groupMeetUpAddress: Address {
        get {
            if _groupMeetUpAddress == nil {
                _groupMeetUpAddress = Address()
            }
            return _groupMeetUpAddress
        }
        set {
            _groupMeetUpAddress = newValue
        }
    }
    
    var groupCreationDate: String {
        get {
            if _groupCreationDate == nil {
                _groupCreationDate = ""
            }
            return _groupCreationDate
        }
        set {
            _groupCreationDate = newValue
        }
    }
    
    var groupStatus: String {
        get {
            if _groupStatus == nil {
                _groupStatus = ""
            }
            return _groupStatus
        }
        set {
            _groupStatus = newValue
        }
    }
    
    var groupHost: String {
        get {
            if _groupHost == nil {
                _groupHost = ""
            }
            return _groupHost
        }
        set {
            _groupHost = newValue
        }
    }
    
    var groupMaxReached: Bool {
        get {
            return _groupMaxReached
        }
        set {
            _groupMaxReached = newValue
        }
    }
}
