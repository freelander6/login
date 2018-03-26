//
//  RegisterAccountVC.swift
//  Login
//
//  Created by George on 17/02/2018.
//  Copyright © 2018 George Woolley. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import SwiftKeychainWrapper
import CFAlertViewController

class RegisterAccountVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var profieImage: UIImageView!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    let picker = UIImagePickerController()
    
   // private var userID = ""
    private var imageURL: String?
    
    var hasTheUserUpdatedProfileImage = false
    var isNoProfilePromptAccepted = false
    var userAccountCreated = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        picker.delegate = self
        // Do any additional setup after loading the view.
    }

    
    @IBAction func registerButtonPressed(_ sender: Any) {
        guard let username = usernameField.text, let email = emailField.text, let password = passwordField.text else {
           presentLoginAlert(title: "Missing information", message: "Ensure all fields are correct")
            return
        }
        
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print("Unable to register user \(String(describing: error))")
                self.presentLoginAlert(title: "Unable to register account, please check your email address", message: error as? String ?? "")
            } else {
                print("New account registered and signed in")
                if let user = user {
                    let userData = ["provider": user.providerID, "username": username]
                    self.storeKeychainAndCreateDBUser(id: user.uid, users: userData)
                    self.userAccountCreated = true
                    
                }
            }
            if Auth.auth().currentUser != nil {
                if let user = user?.uid {
                    self.uploadProfileImage(userID: user)
                    self.performSegue(withIdentifier: "toInitialLocationVC", sender: nil)
                    
                }
                
            }
          
            
        }
        
    
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toInitialLocationVC" {
            if hasTheUserUpdatedProfileImage == false {
                presentNoProfileImageAlert()
            }
        }
        
    }
    
    
    func storeKeychainAndCreateDBUser(id: String, users: Dictionary<String, String>) {
        
        DataService.ds.createFirebaseDBUser(uid: id, users: users)
        
        let val = KeychainWrapper.standard.set(id, forKey: "uid")
        print("Saved to keychain: \(val)")
    }
    
    func uploadProfileImage(userID: String){
        if let imageToUpload = profieImage.image {
            if let imageData = UIImageJPEGRepresentation(imageToUpload, 0.2) {
                
                let metaData = StorageMetadata()
                metaData.contentType = "image/jpeg"
                let imageUID = UUID().uuidString
                DataService.ds.StorageProfile.child(imageUID).putData(imageData, metadata: metaData, completion: { (metadata, error) in
                    if error != nil {
                        self.presentLoginAlert(title: "An error occured uploading your image", message: error as? String ?? "")
                    } else {
                        print("Sucess")
                        if let downloadURL = metadata?.downloadURL()?.absoluteString {
                            DataService.ds.DBrefUsers.child(userID).child("MyDetails").child("profileImageURL").setValue(downloadURL)
                            self.hasTheUserUpdatedProfileImage = true
                            
                        }
                    }
                    
                   
                })
                
            }
        }
        
     
    }
    
    
   
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        profieImage.contentMode = .scaleAspectFill
        profieImage.image = chosenImage
        self.hasTheUserUpdatedProfileImage = true
        dismiss(animated: true, completion: nil)
        
    }
    
    func uploadImageToFirbase() {
        
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func profileImageGesturePressed(_ sender: Any) {
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    
    func presentLoginAlert(title: String, message: String) {
        
        // Create Alet View Controller
        let alertController = CFAlertViewController(title: title,
                                                    message: message,
                                                    textAlignment: .left,
                                                    preferredStyle: .alert,
                                                    didDismissAlertHandler: nil)
        // Create Upgrade Action
        let defaultAction = CFAlertAction(title: "Ok",
                                          style: .Default,
                                          alignment: .center,
                                          backgroundColor: UIColor(red: CGFloat(46.0 / 255.0), green: CGFloat(204.0 / 255.0), blue: CGFloat(113.0 / 255.0), alpha: CGFloat(1)),
                                          textColor: nil,
                                          handler: { (action) in
                                            self.isNoProfilePromptAccepted = true
        })
        // Add Action Button Into Alert
        alertController.addAction(defaultAction)

        // Present Alert View Controller
        present(alertController, animated: true, completion: nil)
     
        
    }
    
    func presentNoProfileImageAlert() {
        // Create Alet View Controller
        let alertController = CFAlertViewController(title: "You have not uploaded a profile image",
                                                    message: "Users with a profile image will recieve a much greater response rate. You can upload an image later under the 'My Profile' page",
                                                    textAlignment: .left,
                                                    preferredStyle: .alert,
                                                    didDismissAlertHandler: nil)
        // Create Upgrade Action
        let defaultAction = CFAlertAction(title: "Continue",
                                          style: .Default,
                                          alignment: .center,
                                          backgroundColor: UIColor(red: CGFloat(46.0 / 255.0), green: CGFloat(204.0 / 255.0), blue: CGFloat(113.0 / 255.0), alpha: CGFloat(1)),
                                          textColor: nil,
                                          handler: { (action) in
                                            if self.userAccountCreated == true {
                                                 self.performSegue(withIdentifier: "toInitialLocationVC", sender: nil)
                                                
                                            }
        })
        

        
        // Add Action Button Into Alert
        alertController.addAction(defaultAction)

        
        // Present Alert View Controller
        present(alertController, animated: true, completion: nil)
        
    }


}
