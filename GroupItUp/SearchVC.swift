//
//  SearchVC.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-04-12.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit
import Firebase

class SearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchStackView: UIStackView!
    @IBOutlet weak var locationBtn: UIButton!
    @IBOutlet weak var categoryBtn: UIButton!
    @IBOutlet weak var keywordBtn: UIButton!
    
    
    let locationSearchOptions = ["Country", "Province", "City"]
    let categorySearchOptions = ["All", "Sport", "Entertainment", "Travel", "Food", "Study", "Other"]
    var locationselected: Bool = true
    var locationOption: String!
    var categoryValue: String!
    var searchButtons: [UIButton]!
    var isSearchByKeyword: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser != nil {
            tableView.delegate = self
            tableView.dataSource = self
            
            tableView.reloadData()
            
            hideKeyboardWhenTappedAround()
            
            initialize()
        } else {
            presentLogInScreen()
        }
    }
    
    func initialize() {
        searchButtons = [locationBtn, categoryBtn, keywordBtn]
        locationBtn.setTitleColor(UIColor.white, for: .normal)
        locationBtn.titleLabel?.font = UIFont(name: locationBtn.titleLabel!.font.fontName, size: 16)
    }
    
    func changeFontDisplayForSearchButtonSelected(searchButton: UIButton) {
        for btn in searchButtons {
            let fontName = btn.titleLabel?.font.fontName
            if btn.isEqual(searchButton) {
                btn.setTitleColor(UIColor.white, for: .normal)
                btn.titleLabel?.font = UIFont(name: fontName!, size: 18)
            } else {
                btn.setTitleColor(UIColor.lightGray, for: .normal)
                btn.titleLabel?.font = UIFont(name: fontName!, size: 16)
            }
        }
    }
    
    func changeSearchOptionList(searchButton: UIButton) {
        switch searchButton {
        case locationBtn:
            locationselected = true
            searchStackView.isHidden = true
            self.tableView.isHidden = false
            self.tableView.reloadData()
            break
        case categoryBtn:
            locationselected = false
            searchStackView.isHidden = true
            self.tableView.isHidden = false
            self.tableView.reloadData()
            break
        case keywordBtn:
            locationselected = false
            searchStackView.isHidden = false
            self.tableView.isHidden = true
            break
        default:
            break
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if locationselected {
            return locationSearchOptions.count
        } else {
            return categorySearchOptions.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell") as! SearchTableViewCell
        var searchOption: String
        if locationselected {
            searchOption = locationSearchOptions[indexPath.row]
        } else {
            searchOption = categorySearchOptions[indexPath.row]
        }
        cell.configureCell(searchOption: searchOption)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if locationselected {
            locationOption = locationSearchOptions[indexPath.row]
            performSegue(withIdentifier: "LocationSearchVC", sender: nil)
        } else {
            categoryValue = categorySearchOptions[indexPath.row]
            performSegue(withIdentifier: "SearchResultVC", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? LocationSearchVC {
            destination.selectedOption = locationOption
        }
        if let destination = segue.destination as? SearchResultVC {
            if isSearchByKeyword == true {
                destination.keyword = searchBar.text
                searchBar.text = nil
                isSearchByKeyword = false
            } else {
                destination.selectedOption = categoryValue
            }
        }
    }
    
    @IBAction func searchBtnPressed(_ sender: UIButton) {
        if searchBar.text == nil || searchBar.text == "" {
            self.sendAlertWithoutHandler(alertTitle: "Missing Keyword", alertMessage: "Please fill in the keyword for your search", actionTitle: ["OK"])
        } else {
            isSearchByKeyword = true
            performSegue(withIdentifier: "SearchResultVC", sender: nil)
        }
        
        
    }
    
    @IBAction func searchOptionSelected(_ sender: UIButton) {
        changeFontDisplayForSearchButtonSelected(searchButton: sender)
        changeSearchOptionList(searchButton: sender)
    }
}
