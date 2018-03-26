//
//  ViewController.swift
//  Login
//
//  Created by George Woolley on 07/11/2017.
//  Copyright © 2017 George Woolley. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase
import SwiftKeychainWrapper
import CFAlertViewController

class LoginPageVC: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
      }
    
   
   override func viewDidAppear(_ animated: Bool) {
        
    if let _  = KeychainWrapper.standard.string(forKey: "uid") {
        performSegue(withIdentifier: "toInitialLocationVC", sender: nil)
    }
    
}
    
    func storeKeychainAndCreateDBUser(id: String, users: Dictionary<String, String>) {
        
        DataService.ds.createFirebaseDBUser(uid: id, users: users)
        
        let val = KeychainWrapper.standard.set(id, forKey: "uid")
        print("Saved to keychain: \(val)")
        performSegue(withIdentifier: "toInitialLocationVC", sender: nil)
    }
    
    
    @IBAction func facebookLoginBnPressed(_ sender: Any) {
        
        let fblogin = FBSDKLoginManager()
        
        fblogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("An error has occured logging into facebook")
            } else {
                print("Succesfully logged into facebook")
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                Auth.auth().signIn(with: credential, completion: { (user, error) in
                    if error != nil {
                        print("An error has occured signing into firebase")
                    } else {
                        print("Successfully signed in as \(String(describing: user))")
                        
                        if let user = user {
                            let userData = ["provider": user.providerID]
                            self.storeKeychainAndCreateDBUser(id: user.uid, users: userData)
                        }
                        
                    }
                })
            }
        }
        
    }
    
    
    @IBAction func RegisterAccountBtnPressed(_ sender: Any) {
        
        
        if KeychainWrapper.standard.string(forKey: "uid") == nil {
            performSegue(withIdentifier: "toRegisterAccountVC", sender: nil)
        } else {
            print("Account already exists")
        }
        
       
        
    }
    
    
    
    @IBAction func emailLoginBtnPressed(_ sender: Any) {
        if let email = emailField.text, let pwd = passwordField.text {
            Auth.auth().signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {   //user signed in with existing account
                    print("Signed in with existing email")
                    if let user = user {
                        let userData = ["provider": user.providerID]
                        self.storeKeychainAndCreateDBUser(id: user.uid, users: userData)
                    }
                    
                } else {
                    print("No user account found, please register a new account")
                    self.presentLoginAlert()
                }
            })
            
            
        }


    }
    
    
        func presentLoginAlert() {

        
        // Create Alet View Controller
        let alertController = CFAlertViewController(title: "User account not recognised",
                                                    message: "Either your username/password is incorrect or you do not yet have a user account",
                                                    textAlignment: .left,
                                                    preferredStyle: .alert,
                                                    didDismissAlertHandler: nil)
        // Create Upgrade Action
        let defaultAction = CFAlertAction(title: "Try again",
                                          style: .Default,
                                          alignment: .center,
                                          backgroundColor: UIColor(red: CGFloat(46.0 / 255.0), green: CGFloat(204.0 / 255.0), blue: CGFloat(113.0 / 255.0), alpha: CGFloat(1)),
                                          textColor: nil,
                                          handler: { (action) in
                                            // Handle btn press
        })
        
        
        let goToRegister = CFAlertAction(title: "Register a new account",
                                           style: .Default,
                                           alignment: .center,
                                           backgroundColor: UIColor(red: CGFloat(46.0 / 255.0), green: CGFloat(204.0 / 255.0), blue: CGFloat(113.0 / 255.0), alpha: CGFloat(1)),
                                           textColor: nil,
                                           handler: { (action) in

                                            self.performSegue(withIdentifier: "toRegisterAccountVC", sender: nil)
        })
        
        
        // Add Action Button Into Alert
        alertController.addAction(defaultAction)
        alertController.addAction(goToRegister)
        // Present Alert View Controller
        present(alertController, animated: true, completion: nil)
        
    }

    
    
    
}
