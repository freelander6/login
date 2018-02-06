//
//  FilterVC.swift
//  Login
//
//  Created by George on 16/01/2018.
//  Copyright © 2018 George Woolley. All rights reserved.
//

import UIKit
import Eureka


class FilterVC: FormViewController {
    
    var filterCount = 0
    
    var rentalTypes = Set<String>()
    var furnishedTypes = Set<String>()
    var billType =  Set<String>()
    var petPolicy =  Set<String>()
    var region = ""
    var city = ""
    var postcode = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpFilterForm()
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "filterResults"  {
            let barViewController = segue.destination as! UITabBarController
            let destination = barViewController.viewControllers![0] as! RentalTableViewVC
            
         // let destination = segue.destination as! RentalTableViewVC
            
            destination.isFilterEnabled = true
            
            let formValues = self.form.values()
            
            if rentalTypes.isEmpty == false {
                 destination.filteredRentalTypes = rentalTypes
                filterCount += 1
            }
//            else {
//                destination.filteredRentalTypes = ["Entire house", "Room in a shared house", "Room share", "Flat", "Apartment", "Other"]
            
            //}
           
            if billType.isEmpty == false {
                destination.filteredBillType = billType
                filterCount += 1
            }
//            else {
//                destination.filteredBillType = ["All bills inluded", "No bills included"]
//            }
        
            if furnishedTypes.isEmpty == false {
                destination.filteredFurnishedType = furnishedTypes
                filterCount += 1
            }
//            else {
//                destination.filteredFurnishedType = ["Fully furnished", "Partly furnished", "Appliances only", "Not furnished"]
//            }
        
            if petPolicy.isEmpty == false {
                destination.filteredPetPolicy = petPolicy
                filterCount += 1
            }
//            else {
//                destination.filteredPetPolicy = ["Pets allowed", "No pets allowed"]
//            }
        
            if region != "" {
                destination.filteredRegion = region
                filterCount += 1
            }
//            else {
//                destination.filteredRegion = "All"
//            }
        
            if let city = formValues["city"] as? String {
                destination.filteredCity = city
                filterCount += 1
            }
//            else {
//                destination.filteredCity = "All"
//            }
            if let postcode = formValues["postcode"] as? String {
               destination.filteredPostCode = postcode
                filterCount += 1
            }
//            else {
//                destination.filteredPostCode = "All"
//            }
        
            if let price = formValues["price"] as? Float {
                destination.filterByPrice = price
                filterCount += 1
            }
//            else {
//                destination.filterByPrice = 2000
//            }
        
          
        
            
          
            
        }
    }

    func setUpFilterForm() {
        
        form +++
            
            Section()
            
            <<< PushRow<String>("region") {
                $0.title = "Filter By Region"
                $0.options = ["All","Northland","Auckland","Waikato","Bay of Plenty","Gisborne","Hawke's Bay","Taranaki","Manawatu-Wanganui","Wellington","Tasman","Nelson","Marlborough","West Coast","Canterbury","Otago","Southland"]
                $0.value = ""
                $0.selectorTitle = "Filter by region"
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
                } .onChange({ (row) in
                    if let val = row.value {
                        self.region = val
                    }
                })
            
            
            <<< NameRow("city") {
                $0.title = "Search By Town/City:"
               // $0.placeholder = "Enter in a city/town to search results"
                }
            
            <<< NameRow("postcode") {
                $0.title = "Search By Postcode:"
               // $0.placeholder = "Search results by postcode"
            }
            
            
            <<< SliderRow("price") {
                $0.title = "Maximum Rent Per Week ($)"
                $0.minimumValue = 1
                $0.maximumValue = 1500
                $0.steps = 100
              
            }
            
            
   
        
            <<< MultipleSelectorRow<String>("type") {
                $0.title = "Filter By Rental Type"
                $0.options = ["Entire house", "Room in a shared house", "Room share", "Flat", "Apartment", "Other"]
       
                } .onChange({ (row) in
                    if let val = row.value {
                        self.rentalTypes = val
                    }                 })
                .onPresent { from, to in
                    
                    to.selectableRowCellUpdate = { cell, row in
                        cell.textLabel!.font = myFont
                        cell.detailTextLabel?.font = myFont
                        //cell.textLabel!.textColor = ...
                        
                    }
            }
            
            
            <<< MultipleSelectorRow<String>("pet") {
                $0.title = "Pet Policy"
                $0.options = ["Pets allowed", "No pets allowed"]
                $0.selectorTitle = "Filter based on pet policy"
                
                
                }.onPresent { from, to in
                    
                    to.selectableRowCellUpdate = { cell, row in
                        cell.textLabel!.font = myFont
                        //cell.textLabel!.textColor = ...
                    }
                    
                }   .onChange({ (row) in
                    if let val = row.value {
                        self.petPolicy = val
                    }
                })
            
            <<< MultipleSelectorRow<String>("furnished") {
                $0.title = "Furnished Status"
                $0.options = ["Fully furnished", "Partly furnished", "Appliances only", "Not furnished"]
               // $0.value = ""
                $0.selectorTitle = "Filter based on furnished status"
              
                
                }.onPresent { from, to in
                    
                    to.selectableRowCellUpdate = { cell, row in
                        cell.textLabel!.font = myFont
                        //cell.textLabel!.textColor = ...
                    }
                    
                }   .onChange({ (row) in
                    if let val = row.value {
                        self.furnishedTypes = val
                    }
                })
            
            
            <<< MultipleSelectorRow<String>("Bills inluded") {
                $0.title = "Bills"
                $0.options = ["All bills inluded", "No bills included"]
                // $0.value = ""
                $0.selectorTitle = "Filter based on furnished status"
                
                
                }.onPresent { from, to in
                    
                    to.selectableRowCellUpdate = { cell, row in
                        cell.textLabel!.font = myFont
                        //cell.textLabel!.textColor = ...
                    }
                    
                }        .onChange({ (row) in
                    if let val = row.value {
                        self.billType = val
                    }
                })
        
        
        form +++
            
            Section()
            <<< ButtonRow() {
                $0.title = "Apply selected filters"
                }
                
                .onCellSelection({ (cell, row) in
                    
                    self.performSegue(withIdentifier: "filterResults", sender: nil)
                    
                })
        
    }
    
    
    
}
