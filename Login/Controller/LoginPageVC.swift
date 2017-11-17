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



class LoginPageVC: UIViewController, FBSDKLoginButtonDelegate {
    

    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print("The following eror has occured \(error)")
            return
        }
           print("Success")
            signUserIntoFB()
        }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Logged off FB")
    }
    
    
    func signUserIntoFB() {
        
        let accessToken = FBSDKAccessToken.current()                                // This is used to feed into check login cred
        guard let accessTokenAsString = accessToken?.tokenString else {return}      // Value as a string
        let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenAsString) //Value used to check fb creds
        
        Auth.auth().signIn(with: credentials) { (user, err) in           // Checking FB creds
            if err != nil {
                print("An error has occured: \(err ?? "" as! Error)")
                return
            }
            print("Successfully signed in FB as:", user ?? "")
            
//            self.navigationController?.popViewController(animated: true)

//            self.performSegue(withIdentifier: "optionsVC", sender: nil)
        }
        
        // Sign into Firebase
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, email, name"]).start { (connection, result, err) in
            
            if err != nil {
                print("Failed with error", err ?? "")
                return
            }
            print(result ?? "")
            self.dismiss(animated: true, completion: nil)
            self.performSegue(withIdentifier: "optionsVC", sender: nil)
        }
    }
    

    let faceBookLoginBtn = FBSDKLoginButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        view.addSubview(faceBookLoginBtn)
        placementOfFacebookBtn()
        faceBookLoginBtn.delegate = self
        //  faceBookLoginBtn.frame = CGRect(x: 16, y: 50, width: view.frame.width - 32, height: 50
}
    
   
   
    
    
    override func viewDidAppear(_ animated: Bool) {
        
    
     
        if FBSDKAccessToken.current() != nil && userloggedOff.isUserLogggedOff == false  {
        self.performSegue(withIdentifier: "optionsVC", sender: nil)
        }
        
        
        
    }
    
    func placementOfFacebookBtn(){         // Using constraints - Better than frames
        
        let horizonalContraints = NSLayoutConstraint(item: faceBookLoginBtn, attribute: .leadingMargin, relatedBy: .equal, toItem: view,   attribute: .leadingMargin, multiplier: 1.0, constant: 20)
        
        let horizonal2Contraints = NSLayoutConstraint(item: faceBookLoginBtn, attribute: .trailingMargin, relatedBy: .equal, toItem: view,
                                                      attribute: .trailingMargin, multiplier: 1.0, constant: -20)
        
        let pinTop = NSLayoutConstraint(item: faceBookLoginBtn, attribute: .top, relatedBy: .equal,
                                        toItem: view, attribute: .top, multiplier: 1.0, constant: 250)
        
        faceBookLoginBtn.translatesAutoresizingMaskIntoConstraints = false   // *** NEEDED
        NSLayoutConstraint.activate([horizonalContraints, horizonal2Contraints,pinTop])
    }
    
    
    

}


 
