//
//  Group.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-04-19.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import Foundation

class Group {
    
    private var _groupID: String!
    private var _groupComments: [Comment]?
    private var _groupDetail: GroupDetail!
    private var _groupPhotos: [Photo]?
    
    init() {
        self._groupID = ""
        self._groupDetail = GroupDetail()
        self._groupComments = [Comment]()
        self._groupPhotos = [Photo]()
    }
    
    init(groupID: String, groupComments: [Comment], groupDetails: GroupDetail, groupPhotos: [Photo]) {
        self._groupID = groupID
        self._groupComments = groupComments
        self._groupDetail = groupDetails
        self._groupPhotos = groupPhotos
    }
    
    var groupID: String {
        get {
            return _groupID
        }
        set {
            _groupID = newValue
        }
    }
    
    var groupComments: [Comment] {
        get {
            if _groupComments != nil {
                return _groupComments!
            } else {
                _groupComments = [Comment]()
                return _groupComments!
            } 
        }
        set {
            _groupComments = newValue
        }
    }
    
    var groupDetail: GroupDetail {
        get {
            return _groupDetail
        }
        set {
            _groupDetail = newValue
        }
    }
    
    var groupPhotos: [Photo] {
        get {
            if _groupPhotos != nil {
                return _groupPhotos!
            } else {
                _groupPhotos = [Photo]()
                return _groupPhotos!
            }
        }
        set {
            _groupPhotos = newValue
        }
    }

}


