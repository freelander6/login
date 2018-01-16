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
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpFilterForm()
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "filterResults"  {
          let destination = segue.destination as! RentalTableViewVC
            let formValues = self.form.values()
            
            if let price = formValues["price"] as? Float {
                destination.filterByPrice = price
            }
         /*   if let test = formValues["test"] as? String {
                destination.test = test
            }
            if let test = formValues["test"] as? String {
                destination.test = test
            } */
            
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
                $0.options = ["Entire House", "Room in Shared House", "Shared Room", "Flat", "Apartment", "Other"]
       
                }
            
            
        
            <<< PushRow<String>("pet") {
                $0.title = "Pet policy"
                $0.options = ["Pets allowed", "No preference"]
                $0.value = ""
                $0.selectorTitle = "Filter based on pet policy"
           
                
                }.onPresent { from, to in
                    
                    to.selectableRowCellUpdate = { cell, row in
                        cell.textLabel!.font = myFont
                        //cell.textLabel!.textColor = ...
                    }
        
 
    }
        
            <<< MultipleSelectorRow<String>("furnished") {
                $0.title = "Furnished Status"
                $0.options = ["Fully Furnished", "Partly Furnished", "Appliances Only", "Not Furnished"]
               // $0.value = ""
                $0.selectorTitle = "Filter based on furnished status"
              
                
                }.onPresent { from, to in
                    
                    to.selectableRowCellUpdate = { cell, row in
                        cell.textLabel!.font = myFont
                        //cell.textLabel!.textColor = ...
                    }
                    
        }
        
            <<< MultipleSelectorRow<String>("Bills inluded") {
                $0.title = "Bills included"
                $0.options = ["All bills inluded", "No bills included", "No preference"]
                // $0.value = ""
                $0.selectorTitle = "Filter based on furnished status"
                
                
                }.onPresent { from, to in
                    
                    to.selectableRowCellUpdate = { cell, row in
                        cell.textLabel!.font = myFont
                        //cell.textLabel!.textColor = ...
                    }
                    
        }
        
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
