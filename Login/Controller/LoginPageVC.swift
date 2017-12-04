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

class LoginPageVC: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      }
    
   
   override func viewDidAppear(_ animated: Bool) {
        
    if let _  = KeychainWrapper.standard.string(forKey: "uid") {
        performSegue(withIdentifier: "optionsVC", sender: nil)
    }
    
}
    
    func storeKeychainAndCreateDBUser(id: String, users: Dictionary<String, String>) {
        
        DataService.ds.createFirebaseDBUser(uid: id, users: users)
        
        let val = KeychainWrapper.standard.set(id, forKey: "uid")
        print("Saved to keychain: \(val)")
        performSegue(withIdentifier: "optionsVC", sender: nil)
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
                    // Authorise with firebase
                    Auth.auth().createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                            print("Unable to authenticate with email/password \(error ?? "" as! Error)")
                        } else {
                            print("New user account created and signed in ")
                            // Store login in keychain so that it can be retrieved later
                            if let user = user {
                                let userData = ["provider": user.providerID]
                                self.storeKeychainAndCreateDBUser(id: user.uid, users: userData )
                            }
                        }
                    })
                }
            })
            
            
        }


    }
}
