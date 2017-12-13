//
//  LandingVC.swift
//  Login
//
//  Created by George Woolley on 07/11/2017.
//  Copyright © 2017 George Woolley. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import SwiftKeychainWrapper
import Firebase


class LandingVC: UIViewController {
    
  @IBAction func logOffPressed(_ sender: Any) {
    
    KeychainWrapper.standard.removeObject(forKey: "uid")
    performSegue(withIdentifier: "loginVC", sender: nil)
    let fbLogin = FBSDKLoginManager()
    fbLogin.logOut()
    
    try! Auth.auth().signOut()
}
    
    @IBAction func pressedLooking(_ sender: Any) {
    }
    
    @IBAction func pressedAdvertising(_ sender: Any) {
        
        performSegue(withIdentifier: "advertising", sender: Any?.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

 

}
