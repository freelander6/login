//
//  SideMenuVC.swift
//  Login
//
//  Created by George on 24/01/2018.
//  Copyright © 2018 George Woolley. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import SwiftKeychainWrapper
import Firebase

class SideMenuVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func logOffPressed(_ sender: Any) {
        KeychainWrapper.standard.removeObject(forKey: "uid")
        performSegue(withIdentifier: "loginVC", sender: nil)
        let fbLogin = FBSDKLoginManager()
        fbLogin.logOut()
        
        try! Auth.auth().signOut()
        
        }
    
    
}
    

