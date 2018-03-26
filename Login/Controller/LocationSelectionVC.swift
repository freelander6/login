//
//  LocationSelectionVC.swift
//  Login
//
//  Created by George on 12/03/2018.
//  Copyright © 2018 George Woolley. All rights reserved.
//

import UIKit
import RangeSeekSlider
import LocationPickerViewController

class LocationSelectionVC: UIViewController {
    
    let defaultLocation = UserDefaults.standard
    

    
    
    @IBOutlet weak var selectLocationBtn: RoundedButton!
   
    @IBOutlet weak var distanceSlider: RangeSeekSlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if userDefaultExist(key: "distance") == true {
            distanceSlider.selectedMaxValue = CGFloat(defaultLocation.double(forKey: "distance"))
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if userDefaultExist(key: "name") == true {
            self.selectLocationBtn.titleLabel?.text = self.defaultLocation.string(forKey: "name")
        }
        
        
            
        
        
      
        
    }
    
    
    @IBAction func selectLocationBtnPressed(_ sender: Any) {
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toLocationPickerVC" {
            let locationPicker = segue.destination as! LocationPicker
            locationPicker.pickCompletion = { (pickedLocationItem) in

                
                if let lat = pickedLocationItem.coordinate?.latitude, let long = pickedLocationItem.coordinate?.longitude {
                    self.defaultLocation.set(lat, forKey: "lat")
                    self.defaultLocation.set(long, forKey: "long")
                    self.defaultLocation.set(pickedLocationItem.name, forKey: "name")
                    
                }
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.defaultLocation.set(Double(distanceSlider.selectedMaxValue), forKey: "distance")

    }
    
    func userDefaultExist(key: String) -> Bool {
        return defaultLocation.object(forKey: key) != nil
    }
    
}
