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


class AdvertFormVC: FormViewController {
    
    private var _rentalTitle :String!
    private var _dateAval : String!
    private var _type: String!
    private var _price: String!
    private var _bond: String!
    private var _furnished: String!
    private var _pets: String!
    private var _email: String!
    private var _street: String!
    private var _city: String!
    private var _postcode: String!
    private var _rentalDescription: String!
    
    var rentalTitle: String? {
        return _rentalTitle
    }
    
    var dateAval: String? {
        return _dateAval
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
    var pets: String? {
        return _pets
    }
    var email: String? {
        return _email
    }
    var street: String?{
        return _street
    }
    var city: String? {
        return _city
    }
    var postcode: String? {
        return _postcode
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
            "date": dateAval as AnyObject,
            "type": type as AnyObject,
            "pets": pets as AnyObject,
            "imageURL": imgURL as AnyObject,
            "email": email as AnyObject,
            "furnished": furnished as AnyObject,
            "ImageID": imageID as AnyObject,
            "street": street as AnyObject,
            "postcode": postcode as AnyObject,
            "city": city as AnyObject
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
        
        DateRow.defaultCellSetup = { cell, row in
            cell.textLabel?.font = myFont
            cell.detailTextLabel?.font = myFont
            
        }
        
        EmailRow.defaultCellSetup = { cell, row in
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
            
            
            <<< IntRow("bond"){
                $0.title = "Bond"
                $0.placeholder = "Inital bond amount required"
                $0.add(rule: RuleGreaterThan(min: 2))
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
            
            
            <<< DateRow("date"){
                $0.title = "Date Available"
                
                $0.value = Date()
                let formatter = DateFormatter()
                formatter.locale = .current
                formatter.dateStyle = .medium
                formatter.timeStyle = .none
                $0.dateFormatter = formatter
            }
            
            <<< PushRow<String>("rentalType") {
                $0.title = "Rental Type"
                $0.options = ["Entire house", "Room in a shared house", "Room share", "Flat", "Apartment", "Other"]
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
            
            <<< PushRow<String>("pet") {
                $0.title = "Pet Policy"
                $0.options = ["Pets allowed", "No pets allowed"]
                $0.value = ""
                $0.selectorTitle = "Pet policy"
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
                $0.options = ["Fully furnished", "Partly furnished", "Appliances only", "Not furnished"]
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
            
            <<< NameRow("street") {
                $0.title = "Street Name:"
                $0.placeholder = "Street name for the property"
                 $0.add(rule: RuleRequired())
                
                }
                .cellSetup { cell, row in
                    cell.imageView?.image = UIImage(named: "plus_image")
                }     .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.textLabel?.textColor = .red
                    }
            }
            
            <<< NameRow("city") {
                $0.title = "City"
                $0.placeholder = "City"
                $0.add(rule: RuleRequired())
                
                }
                .cellSetup { cell, row in
                    cell.imageView?.image = UIImage(named: "plus_image")
                }.cellUpdate { cell, row in
                    if !row.isValid {
                        cell.textLabel?.textColor = .red
                    }
            }
            
            <<< PushRow<String>("Location") {
                $0.title = "Location"
                $0.options = ["Northland","Auckland","Waikato","Bay of Plenty","Gisborne","Hawke's Bay","Taranaki","Manawatu-Wanganui","Wellington","Tasman","Nelson","Marlborough","West Coast","Canterbury","Otago","Southland"]
                $0.value = ""
                $0.selectorTitle = "Select Region"
              
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

            
            <<< NameRow("postcode") {
                $0.title = "Post Code "
                $0.placeholder = "Post Code"
                $0.add(rule: RuleRequired())
                }
                .cellSetup { cell, row in
                    cell.imageView?.image = UIImage(named: "plus_image")
                }    .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.textLabel?.textColor = .red
                    }
            }
            
            <<< SwitchRow("switchRowTag"){
                $0.title = "Share the house number?"
            }
            <<< NameRow("houseNumber"){
                
                $0.hidden = Condition.function(["switchRowTag"], { form in
                    return !((form.rowBy(tag: "switchRowTag") as? SwitchRow)?.value ?? false)
                })
                $0.title = "House number"
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
            
            Section(footer: "Provide a contact email address for viewer enquires.")
            { section in
                var header = HeaderFooterView<UILabel>(.class)
                header.height = { sectionSpacing }
                header.onSetupView = {view, _ in
                    view.textColor = headerColour
                    view.text = "   Contact"
                    view.font = headerFont
                    
                }
                section.header = header
            }
            
            <<< EmailRow("email") {
                $0.title = "Email address"
                $0.placeholder = "Current email address"
                $0.add(rule: RuleRequired())
                $0.add(rule: RuleEmail())
                $0.validationOptions = .validatesOnChangeAfterBlurred
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }        }
        
        
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
        if let bond = formValues["bond"] { self._bond = String(describing: bond!) }
        
        if let date = formValues["date"] {
            self._dateAval = String(describing: date!)
        }
        
        
        if let rental = formValues["rentalType"] { self._type = rental as! String }
        if let pet = formValues["pet"] { self._pets = pet as! String }
        if let furnished = formValues["furnished"] { self._furnished = furnished as! String }
        if let street = formValues["street"] { self._street = street as! String }
        if let city = formValues["city"] { self._city = city as! String }
        if let postcode = formValues["postcode"] { self._postcode = postcode as! String }
        if let description = formValues["rentalDescription"] {self._rentalDescription = description as! String }
        
        if let image = formValues["image1"] {self.rentalImage = image as? UIImage}
        if let email = formValues["email"] {self._email = email as! String}
        
    }
    
    func clearScreen() {
        form.setValues(["title" : "", "rent" : nil, "bond" : nil, "date" : Date(), "rentalType" : "", "pet" : "", "furnished": "", "street" : "", "city" : "", "postcode" : "", "rentalDescription" : "", "image1" : nil, "email" : ""])
        tableView.reloadData()
    }
    

}
