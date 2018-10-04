//
//  BugListVC.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-07-22.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit
import Firebase

class BugListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var defectList: [Defect]!
    var selectedDefect: Defect!
    var isFromBugReportDetailStepVC = false
    private var refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        defectList = [Defect]()
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(fetchDefectList), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing", attributes: nil)
        
        fetchDefectList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if isFromBugReportDetailStepVC == true {
            fetchDefectList()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return defectList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let defect = defectList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "BugListCell") as! BugListCell
        cell.configureCell(bug: defect)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedDefect = defectList[indexPath.row]
        performSegue(withIdentifier: "ViewDefectDetailVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ViewDefectDetailVC {
            destination.selectedDefect = selectedDefect
        }
    }
    
    func fetchDefectList() {
        defectList.removeAll()
        DataService.ds.REF_DEFECTS.observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapShot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapShot {
                    let defectID = snap.key
                    let defectData = snap.value as! Dictionary<String, Any>
                    let defect = Defect()
                    defect.defectID = defectID
                    let defectTitle = defectData["Title"] as! String
                    defect.defectTitle = defectTitle
                    let defectDesc = defectData["Description"] as! String
                    defect.defectDescription = defectDesc
                    let userID = defectData["User ID"] as! String
                    defect.userID = userID
                    let status = defectData["Status"] as! String
                    defect.status = status
                    let defectImageURL = defectData["Defect Image"] as! String
                    defect.defectImageURL = defectImageURL
                    var defectSteps = [Step]()
                    if let defectStepsData = defectData["Steps"] as? Dictionary<String, Any> {
                        for step in defectStepsData {
                            if let defectStepData = step.value as? Dictionary<String, Any> {
                                let defectStep = Step(stepDetails: defectStepData)
                                defectSteps.append(defectStep)
                            }
                        }
                        defect.defectSteps = self.orderDefectStepListByID(steps: defectSteps)
                    }
                    self.defectList.append(defect)
                }
                self.defectList = self.orderDefectListByID(defects: self.defectList)
                self.tableView.reloadData()
            }
        })
    }
    
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "BugReportVC", sender: nil)
    }
    
}
