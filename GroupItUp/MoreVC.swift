//
//  MoreVC.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-04-12.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper
import OpalImagePicker

class MoreVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    let settingOptions = ["Terms of Service", "Privacy Policy", "Feedback", "Bug Report"]
    var termsOfServices = ""
    var isTermsOfServices: Bool!
    var privacyPolicy = ""
    var isPrivacyPolicy: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        processFile()
    }
    
    func processFile() {
        let termsOfServicesURL = Bundle.main.path(forResource: "TermsOfServices", ofType: "txt")
        
        do {
            termsOfServices = try String(contentsOfFile: termsOfServicesURL!, encoding: String.Encoding.utf8)
        } catch let error as NSError {
            print("\(error)")
        }
        
        let privacyPolicyURL = Bundle.main.path(forResource: "PrivacyPolicy", ofType: "txt")
        
        do {
            privacyPolicy = try String(contentsOfFile: privacyPolicyURL!, encoding: String.Encoding.utf8)
        } catch let error as NSError {
            print("\(error)")
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let option = settingOptions[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoreOptionsCell") as! MoreOptionsCell
        cell.configureCell(option: option)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            isTermsOfServices = true
            isPrivacyPolicy = false
            performSegue(withIdentifier: "TermsAndPrivacyVC", sender: nil)
        } else if indexPath.row == 1 {
            isPrivacyPolicy = true
            isTermsOfServices = false
            performSegue(withIdentifier: "TermsAndPrivacyVC", sender: nil)
        } else if indexPath.row == 2 {
            performSegue(withIdentifier: "FeedbackVC", sender: nil)
        } else {
            performSegue(withIdentifier: "BugListVC", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? TermsAndPrivacyVC {
            if isTermsOfServices == true {
                destination.title = "Terms of Services"
                destination.displayText = termsOfServices
            } else if isPrivacyPolicy == true {
                destination.title = "Privacy Policy"
                destination.displayText = privacyPolicy
            }
        }
    }
    
    @IBAction func logOutBtnPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            print("Grandon(SetupVC): the current key is \(Auth.auth().currentUser?.uid)")
            currentUser.reset()
            performSegue(withIdentifier: "LoginVC", sender: nil)
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    

   }
