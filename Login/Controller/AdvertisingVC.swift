//
//  MainVC.swift
//  Login
//
//  Created by George Woolley on 07/11/2017.
//  Copyright © 2017 George Woolley. All rights reserved.
//
/*
import UIKit
import Firebase
import FirebaseDatabase
import SwiftKeychainWrapper


class AvertisingVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
    

    var databaseRef:DatabaseReference?   //reference to firebase dba


    
    let rentalTypePicker = UIPickerView()
    let petsAllowedPicker = UIPickerView()
    let furnishedStatusPicker = UIPickerView()
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return rentalTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return rentalTypes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        rentalTypeField.text = rentalTypes[row]
        rentalTypeField.resignFirstResponder()
    }
    
    
    func createDatePicker() {
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        //done button
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(datePickerDonePressed))
        toolbar.setItems([done], animated: false)
        //add picker to text field
        dateAvalField.inputAccessoryView = toolbar
        dateAvalField.inputView = datePicker
        //format picker for date
        datePicker.datePickerMode = .date
        
    }
    
    @objc func datePickerDonePressed() {
        //formate date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        let dateString = dateFormatter.string(from: datePicker.date)
        dateAvalField.text = "\(dateString)"
        self.view.endEditing(true)
    }
    
    func setupRentalTypePicker() {
    
        rentalTypeField.inputView = rentalTypePicker
        rentalTypePicker.dataSource = self
        rentalTypePicker.delegate = self
        
        rentalTypeField.textAlignment = .center
        rentalTypeField.placeholder = "Select rental type"
    }
    
    func setupPetsAllowedPicker() {
        
        petsField.inputView = petsAllowedPicker
        petsAllowedPicker.dataSource = self
        petsAllowedPicker.delegate = self
        petsField.textAlignment = .center
        petsField.placeholder = "Are pets allowed?"
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageToUpload = image
            imageSelected = true
            uploadImageBtn.setImage(image, for: .normal)
            
        } else {
            print("Invalid image from picker")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        //Firebase Ref
        databaseRef = Database.database().reference().child("Rentals") //can add .child(string:root) to add root dir to dba
        //Date Picker
        createDatePicker()
        //rentalTypePicker
        setupRentalTypePicker()
        
        
         self.descriptionField.layer.cornerRadius = 10
         self.descriptionField.layer.borderWidth = 0.5
         self.descriptionField.layer.borderColor = UIColor(displayP3Red: SHADOW_GREY, green: SHADOW_GREY, blue: SHADOW_GREY, alpha: 0.3).cgColor

        
    }

    @IBAction func backBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func submitForm(_ sender: Any) {      // Send data to firebase on submit
        
//        guard let img = houseBtnImage.currentImage, imageSelected == true else {
//
//            let alert = UIAlertController(title: "You must upload one image to proceed", message: "It's recommended you upload one image before continuing.", preferredStyle: .alert)
//
//            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
//
//
//            self.present(alert, animated: true)
//
//            return
//        }
        
        //Upload image with unique ID as a key
        if let uploadImage = imageToUpload {
            
        
        if let imageData = UIImageJPEGRepresentation(uploadImage, 0.2) {
            
            let imageUID = UUID().uuidString
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"
            
            DataService.ds.StorageREF.child(imageUID).putData(imageData, metadata: metaData) { (metadata, error) in
                if error != nil {
                    print("Error occured uploading data to firebase")
                } else {
                    print("Successfully uploaded image")
                   
                    let downloadURL = metadata?.downloadURL()?.absoluteString
                    
                    if let url = downloadURL {
                        self.postDataToFirbase(imgURL: url, imageID: imageUID)
                        
                    }
                    
                }
                
            }
            
        }
    }
        
    
        
        let alertController = UIAlertController(title: "Success!", message: "You have successfully listed a rental", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Close Alert", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    func postDataToFirbase(imgURL: String, imageID: String) {
        
       
        
        let data: Dictionary<String, AnyObject> = [
       "title": titleField.text as AnyObject,
        "price": rentField.text as AnyObject,
        "description": descriptionField.text as AnyObject,
        "bond": bondField.text as AnyObject,
        "date": dateAvalField.text as AnyObject,
        "type": rentalTypeField.text as AnyObject,
        "pets": petsField.text as AnyObject,
        "imageURL": imgURL as AnyObject,
        "email": emailField.text as AnyObject,
        "furnished": furnishedField.text as AnyObject,
        "ImageID": imageID as AnyObject,
        "address": address.text as AnyObject
        ]
        
        //Post data
        let postDataToRentals = DataService.ds.DBrefRentals.childByAutoId()
        postDataToRentals.setValue(data)
        
        //Clear screen
        titleField.text = ""
        rentField.text = ""
        descriptionField.text = ""
        bondField.text = ""
        rentalTypeField.text = ""
        dateAvalField.text = ""
        petsField.text = ""
        furnishedField.text = ""
        emailField.text = ""
        address.text = "" 
        uploadImageBtn.setImage(#imageLiteral(resourceName: "house"), for: .normal)
      
        
        let postDataToUsers = DataService.ds.DBCurrentUser.child("MyRentals").child(postDataToRentals.key)
        postDataToUsers.setValue(postDataToRentals.key)
        
        
        
    }
    
//    func toggleImageBtn() {
//        if uploadImageBtn.currentTitle == "Upload photo" {
//            uploadImageBtn.setTitle("Photo selected", for: .normal)
//        } else {
//            uploadImageBtn.setTitle("Upload photo", for: .normal)
//        }
//    }
    
    @IBAction func addImageBtnPressed(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    

    
}
*/
