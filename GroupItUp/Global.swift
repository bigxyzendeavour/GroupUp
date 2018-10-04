//
//  Global.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-04-11.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper
import NVActivityIndicatorView

var username: String!
let EMPTY_IMAGE_URL = "https://firebasestorage.googleapis.com/v0/b/groupitup.appspot.com/o/emptyImage.jpg?alt=media&token=506a3a20-cccb-4a6d-9c71-fbf61e0b17e5"
var currentUser = User()
var countries = [String]()
var countries_provinces = [String: Any]()
var provinces = [String]()
var newGroup = Group()
var newGroupForFirebase = [String: Any]()
var newGroupDetailForFirebase = [String: Any]()
var newGroupAddressForFirebase = [String: Any]()
let THEME_COLOR = UIColor(red: 0.957826, green: 0.656833, blue: 0.120666, alpha: 1)
//var inUse = KeychainWrapper.standard.bool(forKey: "In Use Status")
let activityData = ActivityData()
var isRefreshing = false

extension UIView {
    func widthCircleView() {
        layer.cornerRadius = self.frame.width / 2.0
        clipsToBounds = true
    }
    
    func heightCircleView() {
        layer.cornerRadius = self.frame.height / 2.0
        clipsToBounds = true
    }
    
    func heightCircleView(radius: CGFloat) {
        layer.cornerRadius = radius
        clipsToBounds = true
    }
}

extension UIViewController {
    func sendAlertWithoutHandler(alertTitle: String, alertMessage: String, actionTitle: [String]) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        for action in actionTitle {
            alert.addAction(UIAlertAction(title: action, style: .default, handler: nil))
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func sendAlertWithHandler(alertTitle: String, alertMessage: String, actionTitle: [String], handlers:[(_ action: UIAlertAction) -> Void]) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        for i in 0..<actionTitle.count {
            alert.addAction(UIAlertAction(title: actionTitle[i], style: .default, handler: handlers[i]))
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func configureTextFieldWithImage(textFields: [UITextField]) {
        for i in 0..<textFields.count {
            textFields[i].layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
            assignImageToTextField(imageName: i, textField: textFields[i])
        }
    }
    
    func configureTextFieldWithoutImage(textFields: [UITextField]) {
        for i in 0..<textFields.count {
            textFields[i].layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        }
    }
    
    func assignImageToTextField(imageName: Int, textField: UITextField) {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        let name = UIImage().getImageName(name: imageName)
        if name != "" {
                imageView.image = UIImage(named: name)
                textField.leftView = imageView
                textField.leftViewMode = .always
        }
//        imageView.image = UIImage(named: UIImage().getImageName(name: imageName))
//        textField.leftView = imageView
//        textField.leftViewMode = .always
    }
    
    func getUnitIndex(compareUnit: String, unitsArray: [String]) -> Int {
        var index = 0
        for i in 0...unitsArray.count - 1 {
            if compareUnit == unitsArray[i] {
                index = i
            }
        }
        return index
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    func orderCommentsByID(comments: [Comment]) -> [Comment]{
        var newComments = comments
        var newCommentID: Int!
        for i in 0..<comments.count {
            let commentID = comments[i].commentID
            let startIndex = commentID.startIndex
            if commentID[startIndex] == "0" {
                let id = commentID.substring(from: commentID.index(after: startIndex))
                newCommentID = Int(id)
            } else {
                newCommentID = Int(commentID)
            }
            newComments[comments.count - newCommentID] = comments[i]
        }
        return newComments
    }
    
    func orderPhotosByID(photos: [Photo]) -> [Photo] {
        var newPhotos = photos
        var newPhotoID: Int!
        for i in 0..<photos.count {
            let photoID = photos[i].photoID
            let startIndex = photoID.startIndex
            if photoID[startIndex] == "0" {
                let id = photoID.substring(from: photoID.index(after: startIndex))
                newPhotoID = Int(id)
            } else {
                newPhotoID = Int(photoID)
            }
            newPhotos[photos.count - newPhotoID] = photos[i]
        }
        return newPhotos
    }
    
    func orderGroupsByID(groups: [Group]) -> [Group] {
        var newGroups = groups
        for i in 0..<groups.count {
            newGroups[groups.count - 1 - i] = groups[i]
        }
        return newGroups
    }
    
    func orderDefectListByID(defects: [Defect]) -> [Defect] {
        var newDefectList = defects
        for i in 0..<defects.count {
            newDefectList[defects.count - 1 - i] = defects[i]
        }
        return newDefectList
    }
    
    func orderDefectStepListByID(steps: [Step]) -> [Step] {
        var newDefectStepList = steps
        for i in 0..<steps.count {
            let stepNum = steps[i].stepNum
            newDefectStepList[stepNum - 1] = steps[i]
        }
        return newDefectStepList
    }
    
    func reloadSection(tableView: UITableView, indexSection: Int) {
        tableView.beginUpdates()
        let indexSet = NSIndexSet(index: indexSection)
        tableView.reloadSections(indexSet as IndexSet, with: .automatic)
        tableView.endUpdates()
    }
    
    func startRefreshing() {
        isRefreshing = true
        NVActivityIndicatorView.DEFAULT_COLOR = THEME_COLOR
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
    }
    
    func endRefrenshing() {
        isRefreshing = false
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
    }
    
    func presentLogInScreen() {
        performSegue(withIdentifier: "LoginVC", sender: nil)
    }
}

extension UIImage {
    static let IMAGE_EMAIL = 0
    static let IMAGE_PASSWORD = 1
    
    public func getImageName(name: Int) -> String {
        var imageName: String!
        switch name {
        case 0:
            imageName = "profile"
            break
        case 1:
            imageName = "email"
            break
        case 2:
            imageName = "password"
            break
        default:
            imageName = ""
        }
        return imageName
    }

}

extension NSDate {
    
    func fullTimeCreated() -> String {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm"
        return df.string(from: self as Date)
    }
    
    func calculateIntervalBetweenDates(newDate: Date, compareDate: Date) -> Double {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm"
        let interval = compareDate.timeIntervalSince(newDate)
        return Double(interval) / 86400
    }
}
