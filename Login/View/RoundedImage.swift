//
//  RoundedImage.swift
//  Login
//
//  Created by George on 29/12/2017.
//  Copyright © 2017 George Woolley. All rights reserved.
//

import UIKit

class RoundedImage: UIImageView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 25
        clipsToBounds = true
    }

}
