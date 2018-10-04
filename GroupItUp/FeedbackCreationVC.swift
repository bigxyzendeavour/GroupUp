//
//  FeedbackCreationVC.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-07-03.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit
import Firebase

class FeedbackCreationVC: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var feedbackTitleTextField: UITextField!
    @IBOutlet weak var feedbackTextView: UITextView!
    
    var newFeedback: Feedback!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        newFeedback = Feedback()
        
        feedbackTitleTextField.delegate = self
        feedbackTextView.delegate = self
        feedbackTextView.toolbarPlaceholder = "Please help us out by providing feedback."
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        newFeedback.feedbackTitle = feedbackTitleTextField.text!
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        feedbackTextView.textColor = UIColor.black
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == "Please help us out by providing feedback." {
            textView.text = ""
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        newFeedback.feedbackContent = feedbackTextView.text
        if textView.text == "" {
            textView.textColor = UIColor.lightGray
            textView.text = "Please help us out by providing feedback."
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? FeedbackVC {
            destination.feedbacks.insert(newFeedback, at: 0)
        }
    }

   
    @IBAction func submitBtnPressed(_ sender: UIButton) {
        if newFeedback.feedbackTitle != "" && newFeedback.feedbackContent != "" {
            DataService.ds.REF_FEEDBACKS.observeSingleEvent(of: .value, with: { (snapshot) in
                let feedbackCount = snapshot.childrenCount
                var feedbackID: String
                if feedbackCount + 1 < 10 {
                    feedbackID = "0\(feedbackCount + 1)"
                } else {
                    feedbackID = "\(feedbackCount + 1)"
                }
                self.newFeedback = Feedback(feedbackID: feedbackID, feedbackTitle: self.feedbackTitleTextField.text!, feedbackContent: self.feedbackTextView.text!)
                let feedbackForFirebase = ["Created": self.newFeedback.created, "Feedback Description": self.newFeedback.feedbackContent, "Title": self.newFeedback.feedbackTitle, "User ID": self.newFeedback.userID, "Username": self.newFeedback.username]
                DataService.ds.REF_FEEDBACKS.child(feedbackID).updateChildValues(feedbackForFirebase)
                let adminAutoResponseCommentForFirebase = ["01": ["Comment": "Thank you very much for your feedback. Your feedback is valuable.", "User ID": "U328589739844329", "Username": "GroupUpTeam"]]
                DataService.ds.REF_FEEDBACKS.child(feedbackID).child("Comments").updateChildValues(adminAutoResponseCommentForFirebase)
                self.performSegue(withIdentifier: "FeedbackVC", sender: nil)
            })
        } else {
            if newFeedback.feedbackTitle == "" {
                sendAlertWithoutHandler(alertTitle: "Information Incomplete", alertMessage: "Please fill in the feedback title.", actionTitle: ["OK"])
                return
            } else if newFeedback.feedbackContent == "" {
                sendAlertWithoutHandler(alertTitle: "Information Incomplete", alertMessage: "Please provide feedback content before submitting.", actionTitle: ["OK"])
                return
            }
        }
    }

}
