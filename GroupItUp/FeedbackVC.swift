//
//  FeedbackVC.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-06-12.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit
import Firebase

class FeedbackVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var feedbacks = [Feedback]()
    var selectedFeedback: Feedback!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        downloadFeedbackData()
    }
    
    func downloadFeedbackData() {
        DataService.ds.REF_FEEDBACKS.observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapShot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapShot {
                    let feedbackID = snap.key
                    let feedbackData = snap.value as! Dictionary<String, Any>
                    let feedback = Feedback(feedbackID: feedbackID, feedbackData: feedbackData)
                    self.feedbacks.insert(feedback, at: 0)
                }
                self.tableView.reloadData()
            }
        })
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedbacks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let feedback = feedbacks[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedbackTableCell") as! FeedbackTableCell
        cell.configureCell(title: feedback.feedbackTitle)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedFeedback = feedbacks[indexPath.row]
        performSegue(withIdentifier: "FeedbackDetailVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? FeedbackDetailVC {
            destination.selectedFeedback = self.selectedFeedback
        }
    }
    
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "FeedbackCreationVC", sender: nil)
    }
    
}
