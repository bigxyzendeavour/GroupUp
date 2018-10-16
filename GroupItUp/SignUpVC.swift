//
//  SignUpVC.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-04-12.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class SignUpVC: UIViewController {
    
    @IBOutlet weak var termOfServiceAndPrivacyPolicyLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var termsOfServices = ""
    var isTermsOfServices: Bool!
    var privacyPolicy = ""
    var isPrivacyPolicy: Bool!
    
    @IBAction func signUpBtnPressed(_ sender: UIButton) {
        guard let username = usernameTextField.text, username != "" else {
            sendAlertWithoutHandler(alertTitle: "Missing Username", alertMessage: "Please enter your username", actionTitle: ["Cancel"])
            return
        }
        
        guard let email = emailTextField.text, email != "" else {
            sendAlertWithoutHandler(alertTitle: "Missing Email Address", alertMessage: "Please enter your email address", actionTitle: ["Cancel"])
            return
        }
        
        guard let password = passwordTextField.text, password != "" else {
            sendAlertWithoutHandler(alertTitle: "Missing Password", alertMessage: "Please enter your password", actionTitle: ["Cancel"])
            return
        }
        
        if !passwordValidationPassed(password: password) {
            return
        }
    
        processSignUp(username: username, email: email, password: password)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        self.hideKeyboardWhenTappedAround()
     
    }
    
    func initialize() {
        let allTextFields = [usernameTextField, emailTextField, passwordTextField]
        self.configureTextFieldWithImage(textFields: allTextFields as! [UITextField])
        signUpButton.heightCircleView()
        loginButton.heightCircleView()
        
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


    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL, options: [:])
        return false
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    func passwordValidationPassed(password: String) -> Bool {
        var passwordPass = true
        if password.characters.count < 8 {
            sendAlertWithoutHandler(alertTitle: "Password Error", alertMessage: "Password must be at least 8 characters. Please re-enter.", actionTitle: ["OK"])
            passwordPass = false
            return passwordPass
        }
        return passwordPass
    }
    
    func checkExistingUser(snapshot: [DataSnapshot], userName: String) -> Bool {
        var exist = false
        for snap in snapshot {
            if let userSnap = snap.value as? Dictionary<String, Any> {
                if let name = userSnap["Username"] as? String {
                    print("Grandon: username is \(name)")
                    if name == userName {
                        exist = true
                        print("Grandon: is it true? \(exist)")
                        break
                    }
                }
            }
        }
        return exist
    }
    
    func processSignUp(username: String, email: String, password: String) {
        startRefreshing()
        Timer.scheduledTimer(withTimeInterval: 20, repeats: false, block: { (timer) in
            if isRefreshing == true {
                self.endRefrenshing()
                self.sendAlertWithoutHandler(alertTitle: "Error", alertMessage: "Time out, please refresh", actionTitle: ["Cancel"])
                
                return
            }
        })
        DataService.ds.REF_USERS.observeSingleEvent(of: .value, with: { (snapshot) in
            var usernameExisted: Bool
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                usernameExisted = self.checkExistingUser(snapshot: snapshot, userName: username)
                if usernameExisted == true {
                    self.sendAlertWithoutHandler(alertTitle: "Username Exists", alertMessage: "This username has been occupied, please use another.", actionTitle: ["Cancel"])
                    self.endRefrenshing()
                } else {
                    Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                        if let error = error {
                            self.sendAlertWithoutHandler(alertTitle: "Error", alertMessage: error.localizedDescription, actionTitle: ["OK"])
                            let user = user
                            user?.delete(completion: { (error) in
                                self.sendAlertWithoutHandler(alertTitle: "Sign up unsuccessful", alertMessage: "Please re-sign up", actionTitle: ["Cancel"])
                                self.endRefrenshing()
                            })
                        } else {
                            if let user = user {
                                var userData = [String: Any]()
                                let image = UIImage(named: "emptyImage")
                                let imageData = image!.jpegData(compressionQuality: 0.5)
                                let metadata = StorageMetadata()
                                metadata.contentType = "image/jpeg"
                                DataService.ds.STORAGE_USER_IMAGE.child("\(user.uid).jpg").putData(imageData!, metadata: metadata, completion: { (metadata, error) in
                                    if error != nil {
                                        self.endRefrenshing()
                                    } else {
                                        let imageURL = metadata?.downloadURL()?.absoluteString
                                        userData = ["Username": username, "User Display Photo URL": imageURL!]
                                        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                                        changeRequest?.displayName = self.usernameTextField.text!
                                        changeRequest?.photoURL = URL(string: imageURL!)
                                        changeRequest?.commitChanges(completion: { (error) in
                                            if error != nil {
                                                print("Error: \(error?.localizedDescription)")
                                            }
                                            self.completeSignIn(id: user.uid, userData: userData)
                                        })
                                        
                                        Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                                            if error == nil {
                                                print("Grandon: sent email verification")
                                                
                                            } else {
                                                self.sendAlertWithoutHandler(alertTitle: "Not able to send email verification", alertMessage: (error?.localizedDescription)!, actionTitle: ["OK"])
                                            }
                                        })
                                    }
                                })
                            }
                        }
                    })
                }
            }
        })
    }
    
    func completeSignIn(id: String, userData: Dictionary<String, Any>) {
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        currentUser.userID = id
        currentUser.username = (Auth.auth().currentUser?.displayName)!
        currentUser.userDisplayImageURL = (Auth.auth().currentUser?.photoURL?.absoluteString)!
        Storage.storage().reference(forURL: currentUser.userDisplayImageURL).getData(maxSize: 1024 * 1024) { (data, error) in
            if error != nil {
                print("SignUpVC: completeSignIn - \(error?.localizedDescription)")
            } else {
                let image = UIImage(data: data!)
                currentUser.userDisplayImage = image!
                self.performSegue(withIdentifier: "NearbyVC", sender: nil)
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? TermsAndPrivacyVC {
            if isTermsOfServices == true {
                destination.displayText = termsOfServices
            } else if isPrivacyPolicy == true {
                destination.displayText = privacyPolicy
            }
        }
        if let destination = segue.destination as? NearbyVC {
            destination.isFromSignUp = true
        }
    }
    
    @IBAction func termsOfServicesSelected(_ sender: Any) {
        isTermsOfServices = true
        isPrivacyPolicy = false
        performSegue(withIdentifier: "TermsAndPrivacyVC", sender: nil)
    }
    
    @IBAction func privacyPolicySselected(_ sender: Any) {
        isPrivacyPolicy = true
        isTermsOfServices = false
        performSegue(withIdentifier: "TermsAndPrivacyVC", sender: nil)
    }
    
}
