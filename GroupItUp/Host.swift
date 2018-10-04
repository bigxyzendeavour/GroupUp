//
//  Host.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-07-11.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import Foundation

class Host: User {
    
    private var _hostingGroups: [Group]!
    private var _likeGroups: [Group]!
    private var _attendingGroups: [Group]!
    private var _followHosts: [User]!
    private var _joinedGroups: [Group]!
    private var _hostedGroups: [Group]!
    private var _fans: [User]!
    
    override init() {
        super.init()
        _hostingGroups = [Group]()
        _likeGroups = [Group]()
        _attendingGroups = [Group]()
        _joinedGroups = [Group]()
        _hostedGroups = [Group]()
        _followHosts = [User]()
        _fans = [User]()
    }
    
    var hostingGroups: [Group] {
        get {
            return _hostingGroups
        }
        set {
            _hostingGroups = newValue
        }
    }
    
    var hostedGroups: [Group] {
        get {
            return _hostedGroups
        }
        set {
            _hostedGroups = newValue
        }
    }
    
    var likeGroups: [Group] {
        get {
            return _likeGroups
        }
        set {
            _likeGroups = newValue
        }
    }
    
    var attendingGroups: [Group] {
        get {
            return _attendingGroups
        }
        set {
            _attendingGroups = newValue
        }
    }
    
    var joinedGroups: [Group] {
        get {
            return _joinedGroups
        }
        set {
            _joinedGroups = newValue
        }
    }
    
    var followHosts: [User] {
        get {
            return _followHosts
        }
        set {
            _followHosts = newValue
        }
    }
    
    var fans: [User] {
        get {
            return _fans
        }
        set {
            _fans = newValue
        }
    }
}
