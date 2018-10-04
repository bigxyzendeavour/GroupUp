//
//  Defect.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-07-19.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit

class Defect {
    
    private var _defectID: String!
    private var _defectTitle: String!
    private var _defectDescription: String!
    private var _defectImage: UIImage!
    private var _defectImageURL: String!
    private var _defectSteps: [Step]?
    private var _userID: String!
    private var _status: String!
    
    init() {
        
    }
    
    var defectID: String {
        get {
            if _defectID == nil {
                _defectID = ""
            }
            return _defectID
        }
        set {
            _defectID = newValue
        }
    }
    
    var defectTitle: String {
        get {
            if _defectTitle == nil {
                _defectTitle = ""
            }
            return _defectTitle
        }
        set {
            _defectTitle = newValue
        }
    }
    
    var defectDescription: String {
        get {
            if _defectDescription == nil {
                _defectDescription = ""
            }
            return _defectDescription
        }
        set {
            _defectDescription = newValue
        }
    }
    
    var defectImage: UIImage {
        get {
            if _defectImage == nil {
                _defectImage = UIImage()
            }
            return _defectImage
        }
        set {
            _defectImage = newValue
        }
    }
    
    var defectImageURL: String {
        get {
            if _defectImageURL == nil {
                _defectImageURL = ""
            }
            return _defectImageURL
        }
        set {
            _defectImageURL = newValue
        }
    }
    
    var defectSteps: [Step] {
        get {
            if _defectSteps == nil {
                _defectSteps = [Step]()
                let stepOne = Step()
                stepOne.stepNum = 1
                _defectSteps?.append(stepOne)
            }
            return _defectSteps!
        }
        set {
            _defectSteps = newValue
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
    
    var status: String {
        get {
            if _status == nil {
                _status = ""
            }
            return _status
        }
        set {
            _status = newValue
        }
    }
}
