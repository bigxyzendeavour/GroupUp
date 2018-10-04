//
//  Feedback.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-06-14.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit
import Firebase

class Feedback {
    
    private var _feedbackID: String!
    private var _userID: String!
    private var _username: String!
    private var _feedbackTitle: String!
    private var _feedbackContent: String!
    private var _created: String!
    private var _comments: [Comment]?
    
    init() {
        self._feedbackID = ""
        self._username = ""
        self._userID = ""
        self._feedbackTitle = ""
        self._feedbackContent = ""
        self._created = ""
        self._comments = [Comment]()
    }
    
    //Initiate a feedback to be sent, no ID yet, this is set when initiating a comment
    init(feedbackID: String, feedbackTitle: String, feedbackContent: String) {
        self._feedbackID = feedbackID
        self._userID = currentUser.userID
        self._username = currentUser.username
        self._feedbackTitle = feedbackTitle
        self._feedbackContent = feedbackContent
        self._created = "\(NSDate().fullTimeCreated())"
    }
    
    //Download data
    init(feedbackID: String, feedbackData: Dictionary<String, Any>) {
        self._feedbackID = feedbackID
        
        let userID = feedbackData["User ID"] as! String
        self._userID = userID
        
        let feedbackTitle = feedbackData["Title"] as! String
        self._feedbackTitle = feedbackTitle
        
        let feedbackContent = feedbackData["Feedback Description"] as! String
        self._feedbackContent = feedbackContent
        
        let username = feedbackData["Username"] as! String
        self._username = username
        
        let creationTime = feedbackData["Created"] as! String
        self._created = creationTime
        
        if let comments = feedbackData["Comments"] as? Dictionary<String, Any> {
            self._comments = [Comment]()
            for comment in comments {
                let commentID = comment.key
                let commentData = comment.value as! Dictionary<String, String>
                let commentEntry = Comment(commentID: commentID, commentData: commentData)
                self._comments?.append(commentEntry)
            }
        }
    }
    
    var feedbackID: String {
        get {
            if _feedbackID == nil {
                _feedbackID = ""
            }
            return _feedbackID
        }
        set {
            _feedbackID = newValue
        }
    }
    
    var userID: String {
        get {
            if _userID == nil {
                _userID = ""
            }
            return _userID
        }
        set {
            _userID = newValue
        }
    }
    
    var username: String {
        get {
            if _username == nil {
                _username = ""
            }
            return _username
        }
        set {
            _username = newValue
        }
    }
    
    var feedbackTitle: String {
        get {
            if _feedbackTitle == nil {
                _feedbackTitle = ""
            }
            return _feedbackTitle
        }
        set {
            _feedbackTitle = newValue
        }
    }
    
    var feedbackContent: String {
        get {
            if _feedbackContent == nil {
                _feedbackContent = ""
            }
            return _feedbackContent
        }
        set {
            _feedbackContent = newValue
        }
    }
    
    var created: String {
        get {
            if _created == nil {
                _created = ""
            }
            return _created
        }
        set {
            _created = newValue
        }
    }
    
    var comments: [Comment] {
        get {
            if _comments == nil {
                _comments = [Comment]()
            }
            return _comments!
        }
        set {
            _comments = newValue
        }
    }
}
