//
//  LoginVC.swift
//  GroupItUp
//
//  Created by Grandon Lin on 2018-04-11.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper
import NVActivityIndicatorView

class LoginVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var credentialView: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //        navigationController?.navigationBar.barTintColor = UIColor.lightGray
//        navigationItem.hidesBackButton = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
        if Auth.auth().currentUser != nil {
            currentUser.username = (Auth.auth().currentUser?.displayName)!
            currentUser.userDisplayImageURL = (Auth.auth().currentUser?.photoURL?.absoluteString)!
            currentUser.userID = (Auth.auth().currentUser?.uid)!
            Storage.storage().reference(forURL: currentUser.userDisplayImageURL).getData(maxSize: 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print("LoginVC: initialize() - \(error!.localizedDescription)")
                } else {
                    let image = UIImage(data: data!)
                    currentUser.userDisplayImage = image!
                }
                
            })
            DataService.ds.REF_USERS_CURRENT.observeSingleEvent(of: .value, with: { (snapshot) in
                if let snapShot = snapshot.value as? Dictionary<String, Any> {
                    if let region = snapShot["Region"] as? String {
                        currentUser.region = region
                    }
                    if let gender = snapShot["Gender"] as? String {
                        currentUser.gender = gender
                    }
                }
            })
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (timer) in
                self.performSegue(withIdentifier: "NearbyVC", sender: nil)
            })
        }
        self.hideKeyboardWhenTappedAround()
        
    }

    func initialize() {
        let allTextFields = [UITextField(), emailTextField, passwordTextField]
        configureTextFieldWithImage(textFields: allTextFields as! [UITextField])
        loginButton.heightCircleView()
        credentialView.heightCircleView(radius: 15)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? NearbyVC {
            destination.isFromSignUp = true
        }
    }

    @IBAction func logInBtnPressed(_ sender: Any) {
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
//        if !InternetConnection.Connection() {
//            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
//            self.sendAlertWithoutHandler(alertTitle: "Connection Issue", alertMessage: "Please make sure your device is connected to the internet", actionTitle: ["OK"])
//        }
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                if error != nil {
                    print("Grandon: unable to sign in user - \(error)")
                    if error.debugDescription.contains("The password is invalid") {
                        self.sendAlertWithoutHandler(alertTitle: "Login Fail", alertMessage: "The username or password is incorrect. Forget your password? Select 'Forget Password?' to reset your password.", actionTitle: ["OK"])
                    } else if error.debugDescription.contains("There is no user record") {
                        self.sendAlertWithoutHandler(alertTitle: "Login Fail", alertMessage: "The email address entered does not exist. Please enter your email address again.", actionTitle: ["OK"])
                    } else {
                        self.sendAlertWithoutHandler(alertTitle: "Login Fail", alertMessage: "New to GroupItUp? Sign up to enjoy the jurney.", actionTitle: ["OK"])
                    }
                } else {
                    let loggedInUserID = user?.uid
                    DataService.ds.REF_USERS.child(loggedInUserID!).observeSingleEvent(of: .value, with: { (snapshot) in
                        if let snapShot = snapshot.value as? Dictionary<String, Any> {
                            let name = snapShot["Username"] as! String
                            let displayURL = snapShot["User Display Photo URL"] as! String
                            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                            changeRequest?.displayName = name
                            changeRequest?.photoURL = URL(string: displayURL)
                            changeRequest?.commitChanges(completion: { (error) in
                                if error != nil {
                                    print("Error: \(error?.localizedDescription)")
                                    
                                } else {
                                    let id = Auth.auth().currentUser!.uid
                                    self.completeSignIn(id: id)
                                }
                            })
                        }
                    })
                }
            })
        }
    }
    
    func completeSignIn(id: String) {
        currentUser.username = (Auth.auth().currentUser?.displayName)!
        currentUser.userDisplayImageURL = (Auth.auth().currentUser?.photoURL?.absoluteString)!
        currentUser.userID = id
        Storage.storage().reference(forURL: currentUser.userDisplayImageURL).getData(maxSize: 1024 * 1024, completion: { (data, error) in
            if error != nil {
                print("LoginVC: initialize() - \(error!.localizedDescription)")
            } else {
                let image = UIImage(data: data!)
                currentUser.userDisplayImage = image!
            }
            
        })
        performSegue(withIdentifier: "NearbyVC", sender: nil)
    }
    
    @IBAction func forgotPasswordBtnPressed(_ sender: Any) {
        let email = emailTextField.text
        if email != "" {
            Auth.auth().sendPasswordReset(withEmail: email!, completion: { (error) in
                if error.debugDescription.contains("There is no user") {
                    self.sendAlertWithoutHandler(alertTitle: "Forget Password", alertMessage: "There is no user record corresponding to the email address. Please confirm your email address.", actionTitle: ["Cancel"])
                } else {
                    self.sendAlertWithoutHandler(alertTitle: "Reset Email", alertMessage: "An email has been sent to the email address to reset your password.", actionTitle: ["OK"])
                }
            })
        } else {
            self.sendAlertWithoutHandler(alertTitle: "Forget Password", alertMessage: "Missing email address. Please enter your email address.", actionTitle: ["OK"])
        }
    }
    
    @IBAction func signUpBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "SignUpVC", sender: nil)
    }
    
}

