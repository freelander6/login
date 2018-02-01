//
//  InitialLocationVC.swift
//  Login
//
//  Created by George on 31/01/2018.
//  Copyright © 2018 George Woolley. All rights reserved.
//

import UIKit
import SearchTextField

class InitialLocationVC: UIViewController {

    @IBOutlet weak var searchField: SearchTextField!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

      
        
        // Do any additional setup after loading the view.
    }

    
    override func viewDidAppear(_ animated: Bool) {
        searchField.filterStrings(["Northland","Auckland","Waikato","Bay of Plenty","Gisborne","Hawke's Bay","Taranaki","Manawatu-Wanganui","Wellington","Tasman","Nelson","Marlborough","West Coast","Canterbury","Otago","Southland"])
    }

    @IBAction func useCurrentLocationBtnPressed(_ sender: Any) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRentalVC" {
            if let destination = segue.destination as? RentalTableViewVC {
                if let field = searchField.text {
                    destination.filteredCity = field
                    destination.isFilterEnabled = true
                   
                    
                }
               
            }
        }
    }
    
    @IBAction func searchBtnPressed(_ sender: Any) {
        if searchField.text != nil {
            performSegue(withIdentifier: "toRentalVC", sender: nil)
            
            
        }
    }
    
}

