//
//  CurvedImage.swift
//  Login
//
//  Created by George on 30/12/2017.
//  Copyright © 2017 George Woolley. All rights reserved.
//

import UIKit

class CurvedImage: UIImageView {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 10
        clipsToBounds = true    
    }
}
