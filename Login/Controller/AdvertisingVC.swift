//
//  MainVC.swift
//  Login
//
//  Created by George Woolley on 07/11/2017.
//  Copyright © 2017 George Woolley. All rights reserved.
//

import UIKit
import FirebaseDatabase


class AvertisingVC: UIViewController {
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var rentalTypeField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var bondField: UITextField!
    @IBOutlet weak var petsAllowedField: UITextField!
    @IBOutlet weak var detailedDescription: UITextField!
    
    
    
    var databaseRef:DatabaseReference?   //reference to firebase dba
  

    override func viewDidLoad() {
        super.viewDidLoad()
        databaseRef = Database.database().reference().child("Rentals") //can add .child(string:root) to add root dir to dba
    }

    @IBAction func backBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func submitForm(_ sender: Any) {      // Send data to firebase on submit
        
        if titleField.text != nil {
            databaseRef?.child("title").childByAutoId().setValue(titleField.text)
            titleField.text = ""
        }
        
        if  rentalTypeField.text != nil {
            databaseRef?.child("rentalType").childByAutoId().setValue(rentalTypeField.text)
            rentalTypeField.text = ""
        }
        
        if  dateField.text != nil {
            databaseRef?.child("dateAval").childByAutoId().setValue(dateField.text)
            dateField.text = ""
        }
        
        if  locationField.text != nil {
            databaseRef?.child("location").childByAutoId().setValue(locationField.text)
            locationField.text = ""
        }
        
        if  priceField.text != nil {
            databaseRef?.child("price").childByAutoId().setValue(priceField.text)
            priceField.text = ""
        }
        
        if  bondField.text != nil {
            databaseRef?.child("bond").childByAutoId().setValue(bondField.text)
            bondField.text = ""
        }
        
        if  petsAllowedField.text != nil {
            databaseRef?.child("pets").childByAutoId().setValue(petsAllowedField.text)
            petsAllowedField.text = ""
        }
        
        if  detailedDescription.text != nil {
            databaseRef?.child("description").childByAutoId().setValue(detailedDescription.text)
            detailedDescription.text = ""
        }
        
        
        let alertController = UIAlertController(title: "Success!", message: "You have successfully listed a rental", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Close Alert", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
}

