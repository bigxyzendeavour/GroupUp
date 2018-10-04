//
//  BugReportVC.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-07-17.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit

class BugReportVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, BugReportCreationTitleDescriptionCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var selectedBugImage: UIImage!
    var newBug: Defect!
    var imagePicker: UIImagePickerController!
    var emptyImage: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
//        tableView.estimatedRowHeight = tableView.rowHeight
//        tableView.rowHeight = UITableViewAutomaticDimension
        
        newBug = Defect()
        newBug.userID = currentUser.userID
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BugReportCreationTitleDescriptionCell") as! BugReportCreationTitleDescriptionCell
            cell.delegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BugReportImageCell") as! BugReportImageCell
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
            tapGesture.numberOfTapsRequired = 1
            cell.bugImageView.addGestureRecognizer(tapGesture)
            cell.bugImageView.isUserInteractionEnabled = true
            if selectedBugImage != nil {
                cell.configureCell(bugImage: selectedBugImage!)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Screen For The Issue"
        } else {
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat.leastNormalMagnitude
        } else {
            return 25
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 270
        } else {
            return 240
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        selectedBugImage = (info[UIImagePickerControllerEditedImage] as! UIImage)
        newBug.defectImage = selectedBugImage!
        emptyImage = false
        reloadSection(tableView: self.tableView, indexSection: 1)
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    func imageTapped(_ sender: UITapGestureRecognizer) {
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func updateBugTitle(bugTitle: String) {
        newBug.defectTitle = bugTitle
    }
    
    func updateBugDescription(bugDescription: String) {
        newBug.defectDescription = bugDescription
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? BugReportDetailStepVC {
            destination.newBug = newBug
        }
    }
    
    @IBAction func nextBtnPressed(_ sender: UIButton) {
        if emptyImage == true {
            sendAlertWithoutHandler(alertTitle: "Missing Defect Image", alertMessage: "Please provide a screen shot of the issue where it occurs.", actionTitle: ["Cancel"])
        } else if newBug.defectTitle == "" || newBug.defectDescription == "" {
            sendAlertWithoutHandler(alertTitle: "Missing Defect Information", alertMessage: "Please provide a title and a brief description of the issue.", actionTitle: ["Cancel"])
        } else {
            performSegue(withIdentifier: "BugReportDetailStepVC", sender: nil)
        }
    }
    
    
}
