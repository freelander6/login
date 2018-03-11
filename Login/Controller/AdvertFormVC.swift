//
//  AdvertFormVC.swift
//  Login
//
//  Created by George on 10/01/2018.
//  Copyright © 2018 George Woolley. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SwiftKeychainWrapper
import Eureka
import ImageRow
import LocationPickerViewController


class AdvertFormVC: FormViewController {
    
    private var _rentalTitle :String!
    private var _rentalPeriod : String!
    private var _type: String!
    private var _price: String!
    private var _bond: String!
    private var _furnished: String!
    private var _bills: String!
    private var _pets: String!
    private var _userID: String!
    private var _lat : Double!
    private var _long: Double!
    private var _rentalDescription: String!
    
    var rentalTitle: String? {
        return _rentalTitle
    }
    
    var rentalPeriod: String? {
        return _rentalPeriod
    }
    
    var type: String? {
        return _type
    }
    var price: String? {
        return _price
    }
    var bond: String? {
        return _bond
    }
    var furnished: String? {
        return _furnished
    }
    var bills: String? {
        return _bills
    }
    var pets: String? {
        return _pets
    }
    var userID: String? {
        let uid = KeychainWrapper.standard.string(forKey: "uid")
        return uid
    }
    var lat: Double? {
        return _lat
    }
    var long: Double? {
        return _long
    }

    
    var rentalDescription: String? {
        return _rentalDescription
    }
    
    var rentalImage: UIImage?
    
    var databaseRef:DatabaseReference?   //reference to firebase dba
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Firebase Ref
        databaseRef = Database.database().reference().child("Rentals")
        
        loadEurekaForm()
    }

    
////     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
////        if segue.identifier == "toLocationInputVC" {
////            let locationPicker = segue.destination as! LocationPicker
//            locationPicker.pickCompletion = { (pickedLocationItem) in
//
//                self._lat = pickedLocationItem.coordinate?.latitude
//                self._long = pickedLocationItem.coordinate?.longitude
//            }
////        }
////    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toLocationInputVC" {
            let locationPicker = segue.destination as! LocationPicker
            locationPicker.pickCompletion = { (pickedLocationItem) in
                
                self._lat = pickedLocationItem.coordinate?.latitude
                self._long = pickedLocationItem.coordinate?.longitude
            }

        }
    }
    
    
    func upLoadImageAndDataToFirebase() {
        
        if let uploadImage = rentalImage {
            
            
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
        
    }
    
    func postDataToFirbase(imgURL: String, imageID: String) {
        
        
        
        let data: Dictionary<String, AnyObject> = [
            "title": rentalTitle as AnyObject,
            "price": price as AnyObject,
            "description": rentalDescription as AnyObject,
            "bond": bond as AnyObject,
            "rentalPeriod": rentalPeriod as AnyObject,
            "type": type as AnyObject,
            "pets": pets as AnyObject,
            "imageURL": imgURL as AnyObject,
            "userID": userID as AnyObject,
            "furnished": furnished as AnyObject,
             "bills": bills as AnyObject,
            "ImageID": imageID as AnyObject,
            "lat": lat as AnyObject,
            "long": long as AnyObject
        ]
        
        //Post data
        let postDataToRentals = DataService.ds.DBrefRentals.childByAutoId()
        postDataToRentals.setValue(data)
        
        
        let postDataToUsers = DataService.ds.DBCurrentUser.child("MyRentals").child(postDataToRentals.key)
        postDataToUsers.setValue(postDataToRentals.key)
        
    }
    
    
    
    func loadEurekaForm() {
        
        NameRow.defaultCellSetup = { cell, row in
            cell.textLabel?.font = myFont
            cell.detailTextLabel?.font = myFont
            
        }
        
        IntRow.defaultCellSetup = { cell, row in
            cell.textLabel?.font = myFont
            cell.detailTextLabel?.font = myFont
        }
        
     
        PushRow<String>.defaultCellSetup = { cell, row in
            cell.textLabel?.font = myFont
            cell.detailTextLabel?.font = myFont
        }
        
        SwitchRow.defaultCellSetup = { cell, row in
            cell.textLabel?.font = myFont
            cell.detailTextLabel?.font = myFont
        }
        
        ImageRow.defaultCellSetup = { cell, row in
            cell.textLabel?.font = myFont
            cell.detailTextLabel?.font = myFont
        }
        
        
        form +++
            
            Section(){ section in
                var header = HeaderFooterView<UILabel>(.class)
                header.height = { sectionSpacing }
                header.onSetupView = {view, _ in
                    view.textColor = headerColour
                    view.text = "   Rental Details"
                    view.font = headerFont
                    
                }
                section.header = header
            }
            
            
            <<< NameRow("title") {
                $0.title = "Rental Title:"
                
                $0.placeholder = "A short descriptive title"
                $0.add(rule: RuleRequired())
                      }
                .cellSetup { cell, row in
                    cell.imageView?.image = UIImage(named: "plus_image")
                    cell.textField.font = myFont
                    
                    }
                
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                }
                    
            <<< IntRow("rent"){
                $0.title = "Rent"
                $0.placeholder = "Price per week"
                $0.add(rule: RuleGreaterThan(min: 1))
                $0.add(rule: RuleSmallerThan(max: 9999))
                $0.add(rule: RuleRequired())
                let formatter = NumberFormatter()
                formatter.locale = .current
                formatter.numberStyle = .currency
                $0.formatter = formatter
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
            }
            

            
                        
            <<< PushRow<String>("rentalType") {
                $0.title = "Rental Type"
                $0.options = ["Entire house", "Room in a shared house", "Room share", "Flat/Apartment/Self Contained", "Other"]
                $0.value = ""
                $0.selectorTitle = "Select the rental type"
                $0.add(rule: RuleRequired())
                
                }.onPresent { from, to in
                    
                    to.selectableRowCellUpdate = { cell, row in
                        cell.textLabel!.font = myFont
                        //cell.textLabel!.textColor = ...
                    }
                    to.dismissOnSelection = false
                    to.dismissOnChange = false
                } .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.textLabel?.textColor = .red
                    }
            }
            
            <<< PushRow<String>("rentalPeriod") {
                $0.title = "Rental Period"
                $0.options = ["Under 1 Month", "1-3 Months", "3-6 Months", "6-12 Months", "12 Months +"]
                $0.value = ""
                $0.selectorTitle = "Period the rental is available for"
                $0.add(rule: RuleRequired())
                
                }.onPresent { from, to in
                    
                    to.selectableRowCellUpdate = { cell, row in
                        cell.textLabel!.font = myFont
                        //cell.textLabel!.textColor = ...
                    }
                    to.dismissOnSelection = false
                    to.dismissOnChange = false
                } .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.textLabel?.textColor = .red
                    }
            }
            
            <<< PushRow<String>("pet") {
                $0.title = "Pet Policy"
                $0.options = ["Yes", "No"]
                $0.value = ""
                $0.selectorTitle = "Are pets allowed?"
                $0.add(rule: RuleRequired())
                
                }.onPresent { from, to in
                    
                    to.selectableRowCellUpdate = { cell, row in
                        cell.textLabel!.font = myFont
                        //cell.textLabel!.textColor = ...
                    }
                    to.dismissOnSelection = false
                    to.dismissOnChange = false
                }   .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.textLabel?.textColor = .red
                    }
            }
            
            <<< PushRow<String>("furnished") {
                $0.title = "Furnished"
                $0.options = ["Yes", "No"]
                $0.value = ""
                $0.selectorTitle = "Furnished status"
                $0.add(rule: RuleRequired())
                
                }.onPresent { from, to in
                    
                    to.selectableRowCellUpdate = { cell, row in
                        cell.textLabel!.font = myFont
                        //cell.textLabel!.textColor = ...
                    }
                    to.dismissOnSelection = false
                    to.dismissOnChange = false
                }       .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.textLabel?.textColor = .red
                    }
        }
            
            <<< PushRow<String>("bills") {
                $0.title = "Bills included in rental price?"
                $0.options = ["Yes", "No"]
                $0.value = ""
                $0.selectorTitle = "Bills included"
                $0.add(rule: RuleRequired())
                
                }.onPresent { from, to in
                    
                    to.selectableRowCellUpdate = { cell, row in
                        cell.textLabel!.font = myFont
                        //cell.textLabel!.textColor = ...
                    }
                    to.dismissOnSelection = false
                    to.dismissOnChange = false
                }       .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.textLabel?.textColor = .red
                    }
            }
            
        
            <<< SwitchRow("bond"){
                $0.title = "Bond Required?"
            }
            <<< IntRow("bondValue"){
                
                $0.hidden = Condition.function(["bond"], { form in
                    return !((form.rowBy(tag: "bond") as? SwitchRow)?.value ?? false)
                })
                $0.title = "Bond Amount "
                $0.placeholder = "Inital bond amount required"
                $0.add(rule: RuleGreaterThan(min: 2))
                $0.add(rule: RuleSmallerThan(max: 9999))
                let formatter = NumberFormatter()
                formatter.locale = .current
                formatter.numberStyle = .currency
                $0.formatter = formatter

                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                    cell.titleLabel?.textColor = .red
                                        }
                            }

        
        
        form +++
            
            Section(footer: "Include any addtional information viewers may be interested in.")
            { section in
                var header = HeaderFooterView<UILabel>(.class)
                header.height = { sectionSpacing }
                header.onSetupView = {view, _ in
                    view.textColor = headerColour
                    view.text = "    Describe your Rental"
                    view.font = headerFont
                    
                }
                section.header = header
            }
            <<< TextAreaRow("rentalDescription") {
                $0.value = ""
                $0.placeholder = "Enter a detailed description of your Rental."
                
                $0.add(rule: RuleRequired())
                
                }
                .cellSetup({ (cell, row) -> () in
                    cell.textLabel?.font = myFont
                    cell.placeholderLabel?.font = placeHolderFont
                    cell.detailTextLabel?.font = myFont
                    
                })
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.placeholderLabel?.textColor = .red
                    }
        }
        form +++
            
            Section(footer: "Let viewers know where the rental is located.")
            { section in
                var header = HeaderFooterView<UILabel>(.class)
                header.height = { sectionSpacing }
                header.onSetupView = {view, _ in
                    view.textColor = headerColour
                    view.text = "   Location"
                    view.font = headerFont
                    
                }
                section.header = header
            }
            
           
            <<< ButtonRow("location") {
                $0.title = "Location"
                $0.presentationMode = .segueName(segueName: "toLocationInputVC" , onDismiss: nil)
        }
                .cellSetup { cell, row in
                    cell.textLabel?.font = myFont
                }
        
        
        form +++
            Section(footer: "Increase your views but uploading great photos of your property!")
            { section in
                var header = HeaderFooterView<UILabel>(.class)
                header.height = { sectionSpacing }
                header.onSetupView = {view, _ in
                    view.textColor = headerColour
                    view.text = "   Upload photos"
                    view.font = headerFont
                    
                }
                section.header = header
            }
            
            <<< ImageRow("image1") {
                
                $0.title = "Select a photo"
                $0.sourceTypes = .PhotoLibrary
                $0.clearAction = .no
                $0.add(rule: RuleRequired())
                
                }
                .cellUpdate { cell, row in
                    cell.accessoryView?.layer.cornerRadius = 17
                    cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
                    if !row.isValid {
                        cell.textLabel?.textColor = .red
                    }
                }
                .cellSetup { cell, row in
                    cell.imageView?.image = UIImage(named: "plus_image")
            }
            
            
            <<< SwitchRow("img"){
                $0.title = "Upload more images"
            }
            <<< ImageRow(){
                
                $0.hidden = Condition.function(["img"], { form in
                    return !((form.rowBy(tag: "img") as? SwitchRow)?.value ?? false)
                })
                $0.title = "Upload second photo"
                $0.sourceTypes = .PhotoLibrary
                $0.clearAction = .no
                }
                .cellUpdate { cell, row in
                    cell.accessoryView?.layer.cornerRadius = 17
                    cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
                    
                }
                .cellSetup { cell, row in
                    cell.imageView?.image = UIImage(named: "plus_image")
            }
            
            <<< ImageRow(){
                
                $0.hidden = Condition.function(["img"], { form in
                    return !((form.rowBy(tag: "img") as? SwitchRow)?.value ?? false)
                })
                $0.title = "Upload third photo"
                $0.sourceTypes = .PhotoLibrary
                $0.clearAction = .no
                }
                .cellUpdate { cell, row in
                    cell.accessoryView?.layer.cornerRadius = 17
                    cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
                    
                }
                .cellSetup { cell, row in
                    cell.imageView?.image = UIImage(named: "plus_image")
            }
            
            
            <<< ImageRow(){
                
                $0.hidden = Condition.function(["img"], { form in
                    return !((form.rowBy(tag: "img") as? SwitchRow)?.value ?? false)
                })
                $0.title = "Upload fourth photo"
                $0.sourceTypes = .PhotoLibrary
                $0.clearAction = .no
                }
                .cellUpdate { cell, row in
                    cell.accessoryView?.layer.cornerRadius = 17
                    cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
                    
                }
                .cellSetup { cell, row in
                    cell.imageView?.image = UIImage(named: "plus_image")
            }
            
            
            <<< ImageRow(){
                
                $0.hidden = Condition.function(["img"], { form in
                    return !((form.rowBy(tag: "img") as? SwitchRow)?.value ?? false)
                })
                $0.title = "Upload fifth photo"
                $0.sourceTypes = .PhotoLibrary
                $0.clearAction = .no
                }
                .cellUpdate { cell, row in
                    cell.accessoryView?.layer.cornerRadius = 17
                    cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
                    
                }
                .cellSetup { cell, row in
                    cell.imageView?.image = UIImage(named: "plus_image")
        }
        
     
            
        form +++
            
            Section()
            <<< ButtonRow() {
                $0.title = "Submit and list Rental"
                }
                
                .onCellSelection { cell, row in
                    if row.section?.form?.validate().count != 0 {
                        print("Form Validation Failed")
                        row.section?.form?.validate()
                        
                    } else {
                        print("Form validaton successful")
                        self.getFormValues()
                        self.clearScreen()
                        self.upLoadImageAndDataToFirebase()
                        
                    }
                }
                
        
                    
                 
        
                    
            }
    
    
    func getFormValues() {
        
        let formValues = self.form.values()
        if let title = formValues["title"] { self._rentalTitle = title as! String }
        if let rent = formValues["rent"] { self._price = String(describing: rent!) }
        if let bond = formValues["bondValue"] { self._bond = String(describing: bond!) }
        
        if let period = formValues["rentalPeriod"] {
            self._rentalPeriod = String(describing: period!)
        }
        
        
        if let rental = formValues["rentalType"] { self._type = rental as! String }
        if let pet = formValues["pet"] { self._pets = pet as! String }
        if let furnished = formValues["furnished"] { self._furnished = furnished as! String }
        if let bills = formValues["bills"] { self._bills = bills as! String }


        if let description = formValues["rentalDescription"] {self._rentalDescription = description as! String }
        
        if let image = formValues["image1"] {self.rentalImage = image as? UIImage}
     //   if let imageTwo = formValues["image2"] {self.rentalImage = image as? UIImage}
      //  if let imageThree = formValues["image3"] {self.rentalImage = image as? UIImage}
     //   if let imageFour = formValues["image4"] {self.rentalImage = image as? UIImage}
      //  if let imageFive = formValues["image5"] {self.rentalImage = image as? UIImage}

        
    }
    
    func clearScreen() {
        form.setValues(["title" : "", "rent" : nil, "bondValue" : nil, "rentalPeriod" : "", "rentalType" : "", "pet" : "", "furnished": "", "bills": "", "street" : "", "city" : "", "postcode" : "", "houseNumber": "", "rentalDescription" : "", "image1" : nil, "region" : nil])
        tableView.reloadData()
    }
    

}
