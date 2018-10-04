//
//  Step.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-07-20.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit
import Firebase

class Step {
    private var _stepNum: Int!
    private var _stepDescription: String!
    private var _stepImgUrl: String!
    private var _stepImage: UIImage!
    private var _hasImg: Bool!
    private var _imageData: Data!
    private var _metaData: StorageMetadata!
    
    var stepNum: Int {
        get {
            return _stepNum
        }
        set {
            return _stepNum = newValue
        }
    }
    
    var stepDescription: String {
        get {
            return _stepDescription
        }
        set {
            return _stepDescription = newValue
        }
    }
    
    var stepImgUrl: String {
        get {
            return _stepImgUrl
        }
        set {
            return _stepImgUrl = newValue
        }
    }
    
    var stepImage: UIImage {
        get {
            return _stepImage
        }
        set {
            return _stepImage = newValue
        }
    }
    
    var hasImg: Bool {
        get {
            return _hasImg
        }
        set {
            return _hasImg = newValue
        }
    }
    
    var imageData: Data {
        get {
            return _imageData
        }
        set {
            return _imageData = newValue
        }
    }
    
    var metaData: StorageMetadata {
        get {
            return _metaData
        }
        set {
            return _metaData = newValue
        }
    }
    
    init() {
        _stepNum = 0
        _stepDescription = ""
        _stepImage = UIImage(named: "emptyImage")
        _stepImgUrl = EMPTY_IMAGE_URL
        _hasImg = false
        _imageData = Data()
        _metaData = StorageMetadata()
    }
    
    //Initiate when creating steps
    init(stepNum: Int, stepDesc: String, stepImg: UIImage, stepImgUrl: String, imageData: Data, metaData: StorageMetadata) {
        self._stepNum = stepNum
        self._stepDescription = stepDesc
        self._stepImage = stepImg
        self._hasImg = false
        self._stepImgUrl = stepImgUrl
        self._imageData = imageData
        self._metaData = metaData
        
    }
    
    
    //Initiate after downloading from Firebase
    init(stepDetails: Dictionary<String, Any>) {
        
        if let stepDesc = stepDetails["Step Description"] as? String {
            self._stepDescription = stepDesc
        }
        
        if let stepNumber = stepDetails["Step Number"] as? Int {
            self.stepNum = stepNumber
        }
        
        if let stepImageUrl = stepDetails["Step Image URL"] as? String {
            self._stepImgUrl = stepImageUrl
        }
        
        self._stepImage = UIImage()
    }
    
    
    
}
