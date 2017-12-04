//
//  MainVC.swift
//  Login
//
//  Created by George Woolley on 07/11/2017.
//  Copyright © 2017 George Woolley. All rights reserved.
//

import UIKit
import FirebaseDatabase


class AvertisingVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
   
    
    

    @IBOutlet weak var dateAvalField: UITextField!
    @IBOutlet weak var rentalTypeField: UITextField!
    
    
    
    let datePicker = UIDatePicker()
    var databaseRef:DatabaseReference?   //reference to firebase dba
    let rentalTypes = ["Room in shared house", "Entire House","Room Share", "Apartment", "Cottage", "Other"]
    let petsAllowed = ["Yes", "No"]
    let rentalTypePicker = UIPickerView()
    let petsAllowedPicker = UIPickerView()
    
    
    
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
        
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Firebase Ref
        databaseRef = Database.database().reference().child("Rentals") //can add .child(string:root) to add root dir to dba
        //Date Picker
        createDatePicker()
        //rentalTypePicker
        setupRentalTypePicker()
        
    }

    @IBAction func backBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func submitForm(_ sender: Any) {      // Send data to firebase on submit
        
       
        postDataToFirbase()
        
        let alertController = UIAlertController(title: "Success!", message: "You have successfully listed a rental", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Close Alert", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    func postDataToFirbase() {
        
        let data: Dictionary<String, AnyObject> = [:
//        "title": titleField.text as AnyObject,
//        "price": priceField.text as AnyObject,
//        "description": detailedDescription.text as AnyObject,
//        "bond": bondField.text as AnyObject,
//        "type": rentalTypeField.text as AnyObject,
//        "date" : dateField.text as AnyObject,
//        "pets": petsAllowedField.text as AnyObject
        ]
        
        //Post data
        let postDataTo = DataService.ds.DBrefRentals.childByAutoId()
        postDataTo.setValue(data)
        //Clear screen
//        titleField.text = ""
//        priceField.text = ""
//        detailedDescription.text = ""
//        bondField.text = ""
//        rentalTypeField.text = ""
//        dateField.text = ""
//        petsAllowedField.text = ""
    }
    
}

