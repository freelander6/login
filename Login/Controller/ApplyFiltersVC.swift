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
import M13Checkbox


class ApplyFiltersVC: UIViewController, RangeSeekSliderDelegate {
    
    let bondNoCheckbox = M13Checkbox(frame: CGRect(x: 0.0, y: 0.0, width: 20, height: 20))
    let bondYesCheckbox = M13Checkbox(frame: CGRect(x: 0.0, y: 0.0, width: 20, height: 20))
    let billsNoCheckbox = M13Checkbox(frame: CGRect(x: 0.0, y: 0.0, width: 20, height: 20))
    let billsYesCheckbox = M13Checkbox(frame: CGRect(x: 0.0, y: 0.0, width: 20, height: 20))
    let petsNoCheckbox = M13Checkbox(frame: CGRect(x: 0.0, y: 0.0, width: 20, height: 20))
    let petsYesCheckbox = M13Checkbox(frame: CGRect(x: 0.0, y: 0.0, width: 20, height: 20))
    let furnishedNoCheckbox = M13Checkbox(frame: CGRect(x: 0.0, y: 0.0, width: 20, height: 20))
    let furnishedYesCheckbox = M13Checkbox(frame: CGRect(x: 0.0, y: 0.0, width: 20, height: 20))
    
    
    var rangeDelegate: RangeSeekSliderDelegate?

    @IBOutlet weak var filterByPriceLbl: UILabel!
    @IBOutlet weak var filterbyTypeLbl: UILabel!

    @IBOutlet weak var filterByRentalPeriodLbl: UILabel!
    
    @IBOutlet weak var typeDropDown: UIView!
    
    @IBOutlet weak var rentalPeriodDropDown: UIView!

    @IBOutlet weak var priceSlider: RangeSeekSlider!
    
    @IBOutlet weak var bondYesCheck: UIView!
    
    @IBOutlet weak var bondNoCheck: UIView!
    @IBOutlet weak var billsYesCheck: UIView!
    @IBOutlet weak var billsNoCheck: UIView!
    
    @IBOutlet weak var furnishedYesCheck: UIView!
    @IBOutlet weak var furnishedNoCheck: UIView!
    
    

    @IBOutlet weak var petsYesCheck: UIView!
    @IBOutlet weak var petsNoCheck: UIView!
    
    @IBOutlet weak var filterByTypeBtn: UIButton!
    @IBOutlet weak var filterByRentalPeriodBtn: UIButton!
    
    @IBOutlet weak var rentalPeriodBtn: UIButton!


    
    let typeDropdown = DropDown()

    let rentalPeriodDropdown = DropDown()
    
    
    var filterCounter = 0
    var isPriceFilterOn = false
    var isRentalTypeFilterOn = false

    var isRentalPeriodFilterOn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        priceSlider.delegate = self
    
        

    
      updateUI()
        
    

        
    // Setup drop down lists
    typeDropdown.anchorView = typeDropDown
    typeDropdown.dataSource = ["Entire house", "Room in a shared house", "Room share", "Flat/Apartment/Self Contained", "Other"]
     
    rentalPeriodDropdown.anchorView = rentalPeriodDropDown
    rentalPeriodDropdown.dataSource = ["Under 1 Month", "1-3 Months", "3-6 Months", "6-12 Months", "12 Months +"]
        
      
    // Setup custom side bar
    SideMenuManager.default.menuEnableSwipeGestures = false
    SideMenuManager.default.menuWidth = 300
        
        // Do any additional setup after loading the view.
    }

    
    func updateUI() {
        
        bondNoCheck.addSubview(bondNoCheckbox)
        bondYesCheck.addSubview(bondYesCheckbox)
        billsNoCheck.addSubview(billsNoCheckbox)
        billsYesCheck.addSubview(billsYesCheckbox)
        petsNoCheck.addSubview(petsNoCheckbox)
        petsYesCheck.addSubview(petsYesCheckbox)
        furnishedNoCheck.addSubview(furnishedNoCheckbox)
        furnishedYesCheck.addSubview(furnishedYesCheckbox)
        
        rentalPeriodBtn.titleLabel?.textAlignment = .left
        filterByTypeBtn.titleLabel?.textAlignment = .left
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRentalTableView" {
            if let destination = segue.destination as? RentalTableViewVC {
                
                destination.isFilterEnabled = true
                
                destination.filterByMaxPrice = Float(priceSlider.selectedMaxValue)
                destination.filterByMinPrice = Float(priceSlider.selectedMinValue)
            
                if typeDropdown.selectedItem != nil {
                    destination.filteredRentalTypes = typeDropdown.selectedItem
                }
                
                if rentalPeriodDropdown.selectedItem != nil {
                    destination.filteredRentalPeriod = rentalPeriodDropdown.selectedItem
                }
                if furnishedYesCheckbox.checkState == .checked && furnishedNoCheckbox.checkState == .unchecked {
                    destination.filteredFurnishedType = "Yes"
                }
                if furnishedYesCheckbox.checkState == .unchecked && furnishedNoCheckbox.checkState == .checked {
                    destination.filteredFurnishedType = "No"
                }
                if bondYesCheckbox.checkState == .checked && bondNoCheckbox.checkState == .unchecked {
                    destination.filteredBond = "Yes"
                }
                if bondYesCheckbox.checkState == .unchecked && bondNoCheckbox.checkState == .checked {
                    destination.filteredBond = "No"
                }
                if billsYesCheckbox.checkState == .checked && billsNoCheckbox.checkState == .unchecked {
                    destination.filteredBillType = "Yes"
                }
                if  billsYesCheckbox.checkState == .unchecked && bondNoCheckbox.checkState == .checked {
                    destination.filteredBillType = "No"
                }
                if  petsYesCheckbox.checkState == .checked && petsNoCheckbox.checkState == .unchecked {
                    destination.filteredPetPolicy  = "Yes"
                }
                if petsYesCheckbox.checkState == .unchecked && petsNoCheckbox.checkState == .checked {
                    destination.filteredPetPolicy = "No"
                }
                
            }
        }
    }

    @IBAction func applyFilterButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "toRentalTableView", sender: self)
        
        
        
    }
    @IBAction func filterByTypePressed(_ sender: Any) {
        typeDropdown.show()
        
        
        
        typeDropdown.bottomOffset = CGPoint(x: -70, y:(typeDropdown.anchorView?.plainView.bounds.height)!)
        
        
        filterByTypeBtn.setTitle(typeDropdown.selectedItem, for: .normal)
        typeDropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.filterByTypeBtn.setTitle(item, for: .normal)
            self.isRentalTypeFilterOn = true

           
        }
        
        typeDropdown.cancelAction = { [unowned self] in
            self.filterByTypeBtn.setTitle("Select", for: .normal)
            self.isRentalTypeFilterOn = false

        }
    }
    
    

    
    
    @IBAction func rentalPeriodBtnPressed(_ sender: Any) {
        rentalPeriodDropdown.show()
        rentalPeriodDropdown.bottomOffset = CGPoint(x: -155, y:(rentalPeriodDropdown.anchorView?.plainView.bounds.height)!)
        rentalPeriodBtn.setTitle(typeDropdown.selectedItem, for: .normal)
        rentalPeriodDropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.rentalPeriodBtn.setTitle(item, for: .normal)
            self.isRentalPeriodFilterOn = true

            
        }
        
        rentalPeriodDropdown.cancelAction = { [unowned self] in
            self.rentalPeriodBtn.setTitle("Select", for: .normal)
            self.isRentalPeriodFilterOn = false
    
            
        }
    }
    
 
    


    

    
   
    
    
}

