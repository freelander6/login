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
    
    
    var rentalTypes = Set<String>()
    var furnishedTypes = Set<String>()
    var billType =  Set<String>()
    var petPolicy =  Set<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpFilterForm()
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "filterResults"  {
          let destination = segue.destination as! RentalTableViewVC
            destination.isFilterEnabled = true
            
            if rentalTypes.isEmpty == false {
                 destination.filteredRentalTypes = rentalTypes
            } else {
                destination.filteredRentalTypes = ["Entire house", "Room in a shared house", "Room share", "Flat", "Apartment", "Other"]
                
            }
           
            if billType.isEmpty == false {
                destination.filteredBillType = billType
            } else {
                destination.filteredBillType = ["All bills inluded", "No bills included"]
            }
            
            if furnishedTypes.isEmpty == false {
                destination.filteredFurnishedType = furnishedTypes
            } else {
                destination.filteredFurnishedType = ["Fully furnished", "Partly furnished", "Appliances only", "Not furnished"]
            }
            
            if petPolicy.isEmpty == false {
                destination.filteredPetPolicy = petPolicy 
            } else {
                destination.filteredPetPolicy = ["Pets allowed", "No pets allowed"]
            }
            
            
            let formValues = self.form.values()
            
            if let price = formValues["price"] as? Float {
                destination.filterByPrice = price
            }
            
          
        
            
          
            
        }
    }

    func setUpFilterForm() {
        
        form +++
            
            Section()
            
            <<< SliderRow("price") {
                $0.title = "Maximum Rent Per Week ($)"
                $0.value = 2000
                $0.minimumValue = 1
                $0.maximumValue = 2000
            }
            
            
   
        
            <<< MultipleSelectorRow<String>("type") {
                $0.title = "Filter by rental type"
                $0.options = ["Entire house", "Room in a shared house", "Room share", "Flat", "Apartment", "Other"]
       
                } .onChange({ (row) in
                    if let val = row.value {
                        self.rentalTypes = val
                    }                 })
            
            
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
                $0.title = "Bills included"
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
