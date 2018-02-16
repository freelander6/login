//
//  RegisterAccountVC.swift
//  Login
//
//  Created by George on 17/02/2018.
//  Copyright © 2018 George Woolley. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class RegisterAccountVC: UIViewController {

    
    @IBOutlet weak var profieImage: UIImageView!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    @IBAction func registerButtonPressed(_ sender: Any) {
        guard let username = usernameField.text, let email = emailField.text, let password = passwordField.text else {
            print("Not all fields filled in")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print("Unable to register user \(String(describing: error))")
            } else {
                print("New account registered and signed in")
                if let user = user {
                    let userData = ["provider": user.providerID, "username": username]
                    self.storeKeychainAndCreateDBUser(id: user.uid, users: userData)
                    self.performSegue(withIdentifier: "toInitialLocationVC", sender: nil)
                }
            }
        }
        
        
    }
    
    func storeKeychainAndCreateDBUser(id: String, users: Dictionary<String, String>) {
        
        DataService.ds.createFirebaseDBUser(uid: id, users: users)
        
        let val = KeychainWrapper.standard.set(id, forKey: "uid")
        print("Saved to keychain: \(val)")
    }
    
    
    


}
