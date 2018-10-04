//
//  MyFollowUserVC.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-07-13.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit
import Firebase

class MyFollowUserVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var followHosts = [Host]()
    var selectedHost: Host!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Who I'm Following"
        
        tableView.delegate = self
        tableView.dataSource = self
     
        startRefreshing()
        Timer.scheduledTimer(withTimeInterval: 30, repeats: false, block: { (timer) in
            if isRefreshing == true {
                self.endRefrenshing()
                self.sendAlertWithoutHandler(alertTitle: "Error", alertMessage: "Time out, please refresh", actionTitle: ["Cancel"])
                return
            }
        })
        fetchMyFollowUsers()
    }
    
    func fetchMyFollowUsers() {
        DataService.ds.REF_USERS_CURRENT.child("Follow").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.children.allObjects.count == 0 {
                self.sendAlertWithoutHandler(alertTitle: "Empty", alertMessage: "You are not currently  following anyono.", actionTitle: ["OK"])
                return
            }
            
            if let snapShot = snapshot.children.allObjects as? [DataSnapshot] {
                var keyGroups = [String]()
                for snap in snapShot {
                    let userID = snap.key
                    keyGroups.append(userID)
                }
                
                for userID in keyGroups {
                    let eachHost = Host()
                    eachHost.userID = userID
                    
                    DataService.ds.REF_USERS.child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
                        if let snapShot = snapshot.value as? Dictionary<String, Any> {
                            let username = snapShot["Username"] as! String
                            eachHost.username = username
                            let userDisplayUrl = snapShot["User Display Photo URL"] as! String
                            Storage.storage().reference(forURL: userDisplayUrl).getData(maxSize: 1024 * 1024, completion: { (data, error) in
                                if error != nil {
                                    print("\(error?.localizedDescription)")
                                } else {
                                    let image = UIImage(data: data!)
                                    eachHost.userDisplayImage = image!
                                    self.followHosts.append(eachHost)
                                    self.tableView.reloadData()
                                    self.endRefrenshing()
                                }
                               
                            })
                        }
                        
                    })
                }
            }
        })
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followHosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let host = followHosts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyFollowUserCell") as! MyFollowUserCell
        cell.configureCell(host: host)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedHost = followHosts[indexPath.row]
        performSegue(withIdentifier: "HostVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? HostVC {
            destination.host = selectedHost
        }
    }
}
