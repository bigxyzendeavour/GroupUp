//
//  FeedbackDetailVC.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-07-03.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class FeedbackDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentTextField: UITextField!

    var selectedFeedback: Feedback!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        commentTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification
            .Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification
            .Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification
            .Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    @objc func keyboardWillChange(notification: Notification) {
        let keyboardRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        var contentInsets: UIEdgeInsets
        if notification.name == NSNotification.Name.UIKeyboardWillShow || notification.name == NSNotification.Name.UIKeyboardWillChangeFrame {
            view.frame.origin.y = -keyboardRect.height
            contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardRect.height, right: 0.0)
            tableView.contentInset = contentInsets
            tableView.scrollIndicatorInsets = contentInsets
//            let indexPaths = tableView.indexPathsForVisibleRows
//            let index = indexPaths?[0]
//            tableView.scrollToRow(at: index!, at: UITableViewScrollPosition.top, animated: true)
//            tableView.scrollToNearestSelectedRow(at: UITableViewScrollPosition.top, animated: true)
        } else {
            tableView.contentInset = UIEdgeInsets.zero
            tableView.scrollIndicatorInsets = UIEdgeInsets.zero
            view.frame.origin.y = 0
        }
    
        
        
//        if notification.name == NSNotification.Name.UIKeyboardWillShow || notification.name == NSNotification.Name.UIKeyboardWillChangeFrame {
//            view.frame.origin.y = -keyboardRect.height
//            contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardRect.height, right: 0.0)
//            self.navigationController?.navigationBar.frame.origin.y = 0 + 18
//        } else {
//            view.frame.origin.y = 0
            
//            self.navigationController?.navigationBar.frame.origin.y = 0 + 18
//        }
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }

    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            if selectedFeedback.comments.count > 0 {
                return selectedFeedback.comments.count
            } else {
                return 0
            }
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FeedbackDescriptionCell") as! FeedbackDescriptionCell
            cell.configureCell(feedback: selectedFeedback)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FeedbackDetailCommentCell") as! FeedbackDetailCommentCell
            if selectedFeedback.comments.count > 0 {
                let comment = selectedFeedback.comments[indexPath.row]
                cell.configureCell(comment: comment)
            }
            return cell
        }
//        else {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "NearbyGroupCommentEntryCell") as! NearbyGroupCommentEntryCell
//            return cell
//        }
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.section == 2 {
//            return 60
//        } else {
//            return tableView.rowHeight
//        }
//    }
    
    func reloadCommentSection() {
        tableView.beginUpdates()
        let indexPath = IndexPath(row: 0, section: 1)
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    
    @IBAction func sendBtnPressed(_ sender: UIButton) {
        if let comment = commentTextField.text {
            if comment != "" {
                commentTextField.resignFirstResponder()
                let userEntryComment = Comment()
                let commentsCount = selectedFeedback.comments.count
                if commentsCount + 1 < 10 {
                    userEntryComment.commentID = "0\(commentsCount + 1)"
                } else {
                    userEntryComment.commentID = "\(commentsCount)"
                }
                
                userEntryComment.username = currentUser.username
                userEntryComment.userID = currentUser.userID
                userEntryComment.comment = comment
                userEntryComment.userDisplayImage = currentUser.userDisplayImage
                selectedFeedback.comments.insert(userEntryComment, at: 0)
                let commentData = [userEntryComment.commentID: ["Comment": comment, "User ID": userEntryComment.userID, "Username": userEntryComment.username]]
                
                DataService.ds.REF_FEEDBACKS.child(self.selectedFeedback.feedbackID).child("Comments").updateChildValues(commentData)
                commentTextField.text = ""
                reloadCommentSection()
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Comments"
        } else {
            return ""
        }
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if section == 0 {
//            //return nothing
//            return CGFloat.leastNormalMagnitude
//        } else {
//            return 25
//        }
//    }
}
