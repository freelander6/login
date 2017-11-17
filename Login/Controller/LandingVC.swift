//
//  LandingVC.swift
//  Login
//
//  Created by George Woolley on 07/11/2017.
//  Copyright © 2017 George Woolley. All rights reserved.
//

import UIKit
import FBSDKLoginKit


struct userLogin {
    
    var isUserLogggedOff : Bool
}


var userloggedOff = userLogin(isUserLogggedOff: false)


class LandingVC: UIViewController {
    
  @IBAction func logOffPressed(_ sender: Any) {
    userloggedOff.isUserLogggedOff = true 
    
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
