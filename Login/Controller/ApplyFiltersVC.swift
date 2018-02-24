//
//  ApplyFiltersVC.swift
//  Login
//
//  Created by George on 23/02/2018.
//  Copyright © 2018 George Woolley. All rights reserved.
//

import UIKit
import SideMenu
import RangeSeekSlider
import DropDown

class ApplyFiltersVC: UIViewController {


    @IBOutlet weak var typeDropDown: UIView!
    
    @IBOutlet weak var priceSlider: RangeSeekSlider!
    
    @IBOutlet weak var filterByTypeBtn: UIButton!
    
    @IBOutlet weak var rentalPeriodBtn: UIButton!
    @IBOutlet weak var filterByFurnishedBtn: UIButton!
    let typeDropdown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    typeDropdown.anchorView = typeDropDown
    typeDropdown.dataSource = ["Entire house", "Room in a shared house", "Room share", "Flat/Apartment/Self Contained", "Other"]
        
     
        
      
    // Setup custom side bar
    SideMenuManager.default.menuEnableSwipeGestures = false
    SideMenuManager.default.menuWidth = 300
        
        // Do any additional setup after loading the view.
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRentalTableView" {
            if let destination = segue.destination as? RentalTableViewVC {
                destination.filterByPrice = Float(priceSlider.maxValue)
                
                if typeDropdown.selectedItem != nil {
           //         destination.filteredRentalTypes = typeDropdown.selectedItem
                }
            }
        }
    }

    @IBAction func applyFilterButtonPressed(_ sender: Any) {
        
        
    }
    @IBAction func filterByTypePressed(_ sender: Any) {
        typeDropdown.show()
      
        filterByTypeBtn.setTitle(typeDropdown.selectedItem, for: .normal)
        typeDropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.filterByTypeBtn.setTitle(item, for: .normal)
        }
        
        typeDropdown.cancelAction = { [unowned self] in
            self.filterByTypeBtn.setTitle("Filter by Type", for: .normal)
        }
    }
    
 
    @IBAction func filterByFurnishedBtnPressed(_ sender: Any) {
        
    }
    
    
    @IBAction func rentalPeriodBtnPressed(_ sender: Any) {
    }
    
    
}
