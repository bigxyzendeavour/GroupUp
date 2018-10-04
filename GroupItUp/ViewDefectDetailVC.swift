//
//  ViewDefectDetailVC.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-07-23.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit

class ViewDefectDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var selectedDefect: Defect!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 3 {
            return selectedDefect.defectSteps.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ViewDefectTitleCell") as! ViewDefectTitleCell
            cell.configureCell(defect: selectedDefect)
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ViewDefectDisplayCell") as! ViewDefectDisplayCell
            cell.configureCell(defect: selectedDefect)
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ViewDefectDescriptionCell") as! ViewDefectDescriptionCell
            cell.configureCell(defect: selectedDefect)
            return cell
        } else {
            let defectStep = selectedDefect.defectSteps[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "ViewDefectStepCell") as! ViewDefectStepCell
            cell.configureCell(step: defectStep)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 80
        } else if indexPath.section == 1 {
            return 250
        } else if indexPath.section == 2 {
            return 130
        } else {
            return 390
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat.leastNormalMagnitude
        } else {
            return 25
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Screen where issue occurs"
        } else if section == 2 {
            return "Description"
        } else if section == 3 {
            return "Input steps"
        } else {
            return ""
        }
    }
}
