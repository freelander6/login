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
    
    
    var rangeDelegate: RangeSeekSliderDelegate?

    @IBOutlet weak var filterByPriceLbl: UILabel!
    @IBOutlet weak var filterbyTypeLbl: UILabel!
    @IBOutlet weak var furnishedStatusLbl: UILabel!
    @IBOutlet weak var filterByRentalPeriodLbl: UILabel!
    
    @IBOutlet weak var typeDropDown: UIView!
    
    @IBOutlet weak var rentalPeriodDropDown: UIView!
    @IBOutlet weak var furnishedDropDown: UIView!
    @IBOutlet weak var priceSlider: RangeSeekSlider!
    
    @IBOutlet weak var check: UIView!
    
    
    @IBOutlet weak var filterByTypeBtn: UIButton!
    @IBOutlet weak var filterByRentalPeriodBtn: UIButton!
    
    @IBOutlet weak var rentalPeriodBtn: UIButton!
    @IBOutlet weak var filterByFurnishedBtn: UIButton!
    @IBOutlet weak var counterLbl: UILabel!
    
    let typeDropdown = DropDown()
    let furnishedDropdown = DropDown()
    let rentalPeriodDropdown = DropDown()
    
    
    var filterCounter = 0
    var isPriceFilterOn = false
    var isRentalTypeFilterOn = false
    var isFurnishedTypeFilterOn = false
    var isRentalPeriodFilterOn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        priceSlider.delegate = self
    
        
        if filterCounter == 0 {
            counterLbl.isHidden = true
        }
    
        let checkbox = M13Checkbox(frame: CGRect(x: 0.0, y: 0.0, width: 25, height: 25))
        check.addSubview(checkbox)
        
    
        
    // UI Change on label
    counterLbl.layer.cornerRadius = counterLbl.frame.width/2
    counterLbl.layer.masksToBounds = true
        
        
    // Setup drop down lists
    typeDropdown.anchorView = typeDropDown
    typeDropdown.dataSource = ["Entire house", "Room in a shared house", "Room share", "Flat/Apartment/Self Contained", "Other"]
    
    furnishedDropdown.anchorView = furnishedDropDown
    furnishedDropdown.dataSource = ["Furnished", "Not Furnished"]
     
    rentalPeriodDropdown.anchorView = rentalPeriodDropDown
    rentalPeriodDropdown.dataSource = ["Nightly Rental", "Weekly Rental", "3 Months or less", "6 Months or less", "Long Term - 12+ Months"]
        
      
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
        
        
        
        typeDropdown.bottomOffset = CGPoint(x: -95, y:(typeDropdown.anchorView?.plainView.bounds.height)!)
        
        
        filterByTypeBtn.setTitle(typeDropdown.selectedItem, for: .normal)
        typeDropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.filterByTypeBtn.setTitle(item, for: .normal)
            self.isRentalTypeFilterOn = true
            self.refreshFilterLabel()
           
        }
        
        typeDropdown.cancelAction = { [unowned self] in
            self.filterByTypeBtn.setTitle("Filter by Type", for: .normal)
            self.isRentalTypeFilterOn = false
            self.refreshFilterLabel()
        }
    }
    
    
 
    @IBAction func filterByFurnishedBtnPressed(_ sender: Any) {
        furnishedDropdown.show()
        furnishedDropdown.bottomOffset = CGPoint(x: -175, y:(furnishedDropdown.anchorView?.plainView.bounds.height)!)
        filterByFurnishedBtn.setTitle(typeDropdown.selectedItem, for: .normal)
        furnishedDropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.filterByFurnishedBtn.setTitle(item, for: .normal)
            self.isFurnishedTypeFilterOn = true
            self.refreshFilterLabel()
            
        }
        
        furnishedDropdown.cancelAction = { [unowned self] in
            self.filterByFurnishedBtn.setTitle("Filter by furnished status", for: .normal)
            self.isFurnishedTypeFilterOn = false
            self.refreshFilterLabel()
            
        }
    }
    
    
    @IBAction func rentalPeriodBtnPressed(_ sender: Any) {
        rentalPeriodDropdown.show()
        rentalPeriodDropdown.bottomOffset = CGPoint(x: -155, y:(furnishedDropdown.anchorView?.plainView.bounds.height)!)
        rentalPeriodBtn.setTitle(typeDropdown.selectedItem, for: .normal)
        rentalPeriodDropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.rentalPeriodBtn.setTitle(item, for: .normal)
            self.isRentalPeriodFilterOn = true
            self.refreshFilterLabel()
            
        }
        
        rentalPeriodDropdown.cancelAction = { [unowned self] in
            self.rentalPeriodBtn.setTitle("Filter by rental period", for: .normal)
            self.isRentalPeriodFilterOn = false
            self.refreshFilterLabel()
            
        }
    }
    
 
    

    
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        isPriceFilterOn = true
        self.refreshFilterLabel()
    }
    
    
    func refreshFilterLabel() {
        
        filterCounter = 0
        
        if isRentalPeriodFilterOn == true {
            filterCounter += 1
        }
        if isRentalTypeFilterOn == true {
            filterCounter += 1
        }
        if isFurnishedTypeFilterOn == true {
            filterCounter += 1
        }
        
        if isPriceFilterOn == true {
            filterCounter += 1
        }
        
        counterLbl.text = String(filterCounter)
        
        if filterCounter != 0 {
            counterLbl.isHidden = false
        } else {
            counterLbl.isHidden = true
        }
    
        
    }
    
    
}

