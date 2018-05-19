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
        
    //    layer.borderWidth = 0.5
        layer.masksToBounds = false
     //   layer.borderColor =  UIColor.gray.cgColor  //UIColor.black.cgColor
        layer.cornerRadius = frame.height/2
        clipsToBounds = true
        
        
    }

}
