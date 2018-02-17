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

class RegisterAccountVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var profieImage: UIImageView!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    let picker = UIImagePickerController()
    
   // private var userID = ""
    private var imageURL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        picker.delegate = self
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
                    
                }
            }
            if Auth.auth().currentUser != nil {
                if let user = user?.uid {
                    self.uploadProfileImage(userID: user)
                  //  DataService.ds.DBrefUsers.child(user).child("MyDetails").child("profileImageURL").setValue(imgURL)
                    self.performSegue(withIdentifier: "toInitialLocationVC", sender: nil)                }
             
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
                        print("Error occured uploading profile image")
                    } else {
                        print("Sucess")
                        if let downloadURL = metadata?.downloadURL()?.absoluteString {
                            DataService.ds.DBrefUsers.child(userID).child("MyDetails").child("profileImageURL").setValue(downloadURL)
                            
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
        dismiss(animated: true, completion: nil)
        
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
    


}
