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


class MyAccountVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var profilePictureImg: UIImageView!
    @IBOutlet weak var usernameField: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var changeProfilePicButton: UIButton!
    
    let picker = UIImagePickerController()
    let myUID = KeychainWrapper.standard.string(forKey: "uid")
    
    var oldImgURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        
        
        if myUID == nil {
            print("You are not logged in")
        } else {
            
            let ref = DataService.ds.DBCurrentUser
            ref.child("MyDetails").observe(.value, with: { (snapshot) in
                
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                    for snap in snapshots {
                        if snap.key == "username" {
                            self.usernameField.text = snap.value as? String
                        }
                        if snap.key == "profileImageURL" {
                            if let url = snap.value as? String {
                                let ref = Storage.storage().reference(forURL: url)
                                ref.getData(maxSize:  2 * 1024 * 1024, completion: { (data, error) in
                                    if error != nil {
                                        print("An error has occured downloading image")
                                    } else {
                                        print("Image downloaded")
                                        if let imageData = data {
                                            if let img = UIImage(data: imageData) {
                                                self.profilePictureImg.image = img
                                                
                                            }
                                        }
                                    }
                                })
                            }
                          
                        }
                        
                    }
                }
           })
        }
        
        
    }
    
    
    
    
func removeImgFromFirebaseStorage() {
    
    
    let ref = DataService.ds.DBCurrentUser.child("MyDetails")
    
    var arrayOfUrls = [String]()
    
    ref.observe(.value) { (snapshot) in
        if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
            for snap in snapshots {
                if snap.key == "profileImageURL" {
                    arrayOfUrls.append((snap.value as? String)!)
            }
        }
    }

    
    
       
            
            let oldImage = Storage.storage().reference(forURL: arrayOfUrls[0])
            oldImage.delete { (error) in
                if error != nil {
                    print("Error")
                } else {
                    print("delete successull")
                }
            }
        
        
        
        self.saveButton.isHidden = false
        self.changeProfilePicButton.isHidden = true
  
    }
}


    
    func uploadImageToFirebase() {
        
        if let imageToUpload = profilePictureImg.image {
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
                            DataService.ds.DBCurrentUser.child("MyDetails").child("profileImageURL").setValue(downloadURL)
                            
                        }
                    }
                    
                    
                })
                
            }
        }
        
        saveButton.isHidden = false
        changeProfilePicButton.isHidden = true

    }
    
    
    @IBAction func saveButonPressed(_ sender: Any) {
        uploadImageToFirebase()
    }
    
    @IBAction func changeProfilePicturePressed(_ sender: Any) {
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }

    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        profilePictureImg.contentMode = .scaleAspectFill
        profilePictureImg.image = chosenImage
        dismiss(animated: true, completion: removeImgFromFirebaseStorage)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func logOffPressed(_ sender: Any) {
        
        KeychainWrapper.standard.removeObject(forKey: "uid")
        performSegue(withIdentifier: "loginVC", sender: nil)
        let fbLogin = FBSDKLoginManager()
        fbLogin.logOut()
        
        try! Auth.auth().signOut()
    }
}

