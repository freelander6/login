//
//  CurvedBorderForLabel.swift
//  Login
//
//  Created by George on 31/12/2017.
//  Copyright © 2017 George Woolley. All rights reserved.
//

import UIKit

class CurvedBorderForLabel: UILabel {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 10
        layer.borderWidth = 0.5
        layer.masksToBounds = false
        layer.borderColor = UIColor(displayP3Red: SHADOW_GREY, green: SHADOW_GREY, blue: SHADOW_GREY, alpha: 0.4).cgColor
        
    }

}
