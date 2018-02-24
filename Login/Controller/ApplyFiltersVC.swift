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

class ApplyFiltersVC: UIViewController {


    @IBOutlet weak var priceSlider: RangeSeekSlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
    
        
    // Setup custom side bar
    SideMenuManager.default.menuEnableSwipeGestures = false
    SideMenuManager.default.menuWidth = 300
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
