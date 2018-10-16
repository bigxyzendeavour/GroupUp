//
//  BugReportDetailStepVC.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-07-23.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit
import Firebase

class BugReportDetailStepVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, DefectStepCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var adjustButtn: UIButton!

    var newBug: Defect!
    var imagePicker: UIImagePickerController!
    var selectedBugImage: UIImage!
    var selectedIndex: Int!
    var number: Int!
    var newBugForFirebase: Dictionary<String, Any>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        
        newBugForFirebase = [String: Any]()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newBug.defectSteps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefectStepCell") as! DefectStepCell
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        tapGesture.numberOfTapsRequired = 1
        cell.stepImage.addGestureRecognizer(tapGesture)
        cell.stepImage.isUserInteractionEnabled = true
        let step = newBug.defectSteps[indexPath.row]
        cell.configureCell(step: step)
        cell.step = step
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let sourceStep = newBug.defectSteps[sourceIndexPath.row]
        
        if sourceIndexPath.row > destinationIndexPath.row {
            newBug.defectSteps.insert(sourceStep, at: destinationIndexPath.row)
            newBug.defectSteps.remove(at: sourceIndexPath.row + 1)
            for step in newBug.defectSteps {
                
                if step.stepNum > destinationIndexPath.row && step.stepNum <= sourceIndexPath.row {
                    step.stepNum += 1
                }
            }
            
            let destStep = newBug.defectSteps[destinationIndexPath.row]
            destStep.stepNum = destinationIndexPath.row + 1
        } else {
            newBug.defectSteps.insert(sourceStep, at: destinationIndexPath.row + 1)
            newBug.defectSteps.remove(at: sourceIndexPath.row)
            //                0       1      2      3      4      5
            //            [Step1, Step2, Step3, Step4, Step5, Step6]
            //            [Step1, Step3, Step4, Step2, Step5, Step6]
            for step in newBug.defectSteps {
                if step.stepNum > sourceIndexPath.row + 1 && step.stepNum <= destinationIndexPath.row + 1 {
                    step.stepNum -= 1
                }
            }
        }
        let destStep = newBug.defectSteps[destinationIndexPath.row]
        destStep.stepNum = destinationIndexPath.row + 1
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        //        [Step1, Step2, Step3, Step4, Step5]
        //        [Step1, Step2, Step4, Step5]
        //        [Step1, Step2, Step3, Step4]
        
        tableView.beginUpdates()
        newBug.defectSteps.remove(at: indexPath.row)
        for step in newBug.defectSteps {
            if step.stepNum > indexPath.row {
                if step.stepNum > newBug.defectSteps.count {
                    step.stepNum -= 1
                } else if step.stepNum <= newBug.defectSteps.count {
                    step.stepNum -= 1
                }
            }
        }
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.reloadData()
        tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 360
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        if let selectedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
            let index = NSIndexPath(row: selectedIndex, section: 0) as IndexPath
            if let cell = tableView(tableView, cellForRowAt: index) as? DefectStepCell {
                cell.stepImage.image = selectedImage
            }
            
            let step = newBug.defectSteps[selectedIndex]
            step.stepImage = selectedImage
            step.hasImg = true
            newBug.defectSteps[selectedIndex] = step
            tableView.reloadRows(at: [index], with: .automatic)
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: tableView)
        let ip = tableView.indexPathForRow(at: location)!
        selectedIndex = ip.row
        present(imagePicker, animated: true, completion: nil)

    }
    
    @IBAction func addStepBtnPressed(_ sender: UIButton) {
        let stepImgUrl = EMPTY_IMAGE_URL
        let newStep = Step(stepNum: newBug.defectSteps.count + 1, stepDesc: "", stepImg: UIImage(named: "emptyImage")!, stepImgUrl: stepImgUrl, imageData: Data(), metaData: StorageMetadata())
        newBug.defectSteps.append(newStep)
        
        let indexPath = IndexPath(row: newBug.defectSteps.count - 1, section: 0)
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
        tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
    }
    
    @IBAction func adjustStepBtnPressed(_ sender: UIButton) {
        if tableView.isEditing {
            adjustButtn.setTitle("Adjust Steps", for: .normal)
            tableView.setEditing(false, animated: true)
            tableView.reloadData()
        } else {
            tableView.setEditing(true, animated: true)
            adjustButtn.setTitle("Complete Editing", for: .normal)
        }
    }
    
    @IBAction func cancelBtnPressed(_ sender: UIBarButtonItem) {
        let yesHandler = { (action: UIAlertAction) -> Void in
            self.backToBugListVC(index: 3)
        }
        let cancelHandler = { (action: UIAlertAction) -> Void in
            return
        }
        sendAlertWithHandler(alertTitle: "Cancel Item", alertMessage: "Cancelling a defect report, this item will not be saved or submitted, are you sure?", actionTitle: ["Yes", "Cancel"], handlers: [yesHandler, cancelHandler])
    }
    
    func backToBugListVC(index: Int) {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        if let destinationVC = viewControllers[viewControllers.count - index] as? BugListVC {
            destinationVC.isFromBugReportDetailStepVC = true
            self.navigationController!.popToViewController(destinationVC, animated: true)
        }
        
    }
    
    func performValidation() -> Bool {
        var validationPassed = true
        for bugStep in newBug.defectSteps {
            if !bugStep.hasImg {
                validationPassed = false
                self.sendAlertWithoutHandler(alertTitle: "Missing Image", alertMessage: "One or more of your steps are missing screen shot(s), please provide the screen shot.", actionTitle: ["OK"])
            }
            if bugStep.stepDescription == "" {
                validationPassed = false
                self.sendAlertWithoutHandler(alertTitle: "Missing Description", alertMessage: "Please provide a brief description of each step.", actionTitle: ["OK"])
                
            }
        }
        return validationPassed
    }
    
    @IBAction func submitBtnPressed(_ sender: UIButton) {
        
        if performValidation() == false {
            return
        }
        
        startRefreshing()
        DataService.ds.REF_DEFECTS.observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapShot = snapshot.children.allObjects as? [DataSnapshot] {
                let snapCount = snapShot.count
                if snapCount + 1 < 10 {
                    self.newBug.defectID = "0\(snapCount + 1)"
                } else {
                    self.newBug.defectID = "\(snapCount + 1)"
                }
                
                let defectID = self.newBug.defectID
                let defectDescription = self.newBug.defectDescription
                let defectTitle = self.newBug.defectTitle
                let userID = currentUser.userID
                self.newBug.userID = userID
                
                var allDefectImages = [UIImage]()
                allDefectImages.append(self.newBug.defectImage)
                
                var defectStepsData = [String: Any]()
                for step in self.newBug.defectSteps {
                    let stepNum = step.stepNum
                    var stepID: String
                    if stepNum < 10 {
                        stepID = "0\(stepNum)"
                    } else {
                        stepID = "\(stepNum)"
                    }
                    let stepDesc = step.stepDescription
                    defectStepsData[stepID] = ["Step Description": stepDesc, "Step Number": step.stepNum]
                    let stepImage = step.stepImage
                    allDefectImages.append(stepImage)
                }
                
                for i in 0..<allDefectImages.count {
                    let image = allDefectImages[i]
                    if let imageData = image.jpegData(compressionQuality: 0.5) {
                        let metadata = StorageMetadata()
                        metadata.contentType = "image/jpeg"
                        if i == 0 {
                            DataService.ds.STORAGE_DEFECT_IMAGE.child(defectID).child("\(defectID).jpg").putData(imageData, metadata: metadata) {
                                (data, error) in
                                if error != nil {
                                    print("\(error?.localizedDescription)")
                                } else {
                                    let imageURL = data?.downloadURL()?.absoluteString
                                    DataService.ds.REF_DEFECTS.child(defectID).child("Defect Image").setValue(imageURL!)
                                }
                            }
                        } else {
                            let stepID = "0\(i)"
                            
                            
                            DataService.ds.STORAGE_DEFECT_IMAGE.child(defectID).child("Step\(i).jpg").putData(imageData, metadata: metadata) {
                                (data, error) in
                                if error != nil {
                                    print("\(error?.localizedDescription)")
                                } else {
                                    let imageURL = data?.downloadURL()?.absoluteString
                                    DataService.ds.REF_DEFECTS.child(defectID).child("Steps").child(stepID).child("Step Image URL").setValue(imageURL!)
                                    if i == allDefectImages.count - 1 {
                                        self.endRefrenshing()
                                        self.backToBugListVC(index: 3)
                                    }
                                }
                            }
                        }
                        
                    }
                }
                
                self.newBugForFirebase = [defectID: ["Description": defectDescription, "Title": defectTitle, "User ID": userID, "Status": "Submitted", "Steps": defectStepsData]]
                DataService.ds.REF_DEFECTS.updateChildValues(self.newBugForFirebase)
            }
        })
    }
    
    func updateStep(step: Step) {
        if newBug.defectSteps.count == 1 {
            newBug.defectSteps.remove(at: 0)
            newBug.defectSteps.append(step)
        } else {
            let stepNumber = step.stepNum
            newBug.defectSteps[stepNumber - 1] = step
        }
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
