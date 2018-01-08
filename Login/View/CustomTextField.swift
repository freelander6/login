//
//  CustomTextField.swift
//  Login
//
//  Created by George on 07/01/2018.
//  Copyright © 2018 George Woolley. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 10
        layer.borderWidth = 0.5
        layer.masksToBounds = false
        layer.borderColor = UIColor(displayP3Red: SHADOW_GREY, green: SHADOW_GREY, blue: SHADOW_GREY, alpha: 0.4).cgColor
        
    }
    
   

}
