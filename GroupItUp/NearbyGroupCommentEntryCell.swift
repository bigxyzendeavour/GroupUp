//
//  NearbyGroupCommentEntryCell.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-04-25.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit
import Firebase

protocol NearbyGroupCommentEntryCellDelegate {
    func reloadCommentSection()
    func updateComments(comments: [Comment])
}

class NearbyGroupCommentEntryCell: UITableViewCell {

    @IBOutlet weak var commentTextField: UITextField!
    
    var selectedGroup: Group!
    var delegate: NearbyGroupCommentEntryCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell() {
        commentTextField.placeholder = "Leave a comment"
    }

    func setSelectedGroup(group: Group) {
        selectedGroup = group
    }

    @IBAction func sendBtnPressed(_ sender: UIButton) {
        if let comment = commentTextField.text {
            if comment != "" {
                commentTextField.resignFirstResponder()
                var comments = selectedGroup.groupComments
                let userEntryComment = Comment()
                userEntryComment.username = currentUser.username
                userEntryComment.userID = currentUser.userID
                userEntryComment.comment = comment
                let count = comments.count
                if count + 1 < 10 {
                    userEntryComment.commentID = "0\(count + 1)"
                } else {
                    userEntryComment.commentID = "\(count + 1)"
                }
                
                DataService.ds.STORAGE_USER_IMAGE.child("\(currentUser.userID).jpg").getData(maxSize: 1024 * 1024) { (data, error) in
                    if error != nil {
                        print("Comment(2): Error - \(error!.localizedDescription)")
                    } else {
                        let image = UIImage(data: data!)
                        userEntryComment.userDisplayImage = image!
                        comments.insert(userEntryComment, at: 0)
                        let commentData = [userEntryComment.commentID: ["Comment": comment, "User ID": userEntryComment.userID, "Username": userEntryComment.username]]

                        DataService.ds.REF_GROUPS.child(self.selectedGroup.groupID).child("Comments").updateChildValues(commentData)
                        
                        if let delegate = self.delegate {
                            delegate.updateComments(comments: comments)
                            delegate.reloadCommentSection()
                        }
                        self.commentTextField.text = ""
                    }
                }
                
            }
        }
    }

}
