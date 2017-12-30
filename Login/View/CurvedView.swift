//
//  CurvedView.swift
//  Login
//
//  Created by George on 31/12/2017.
//  Copyright © 2017 George Woolley. All rights reserved.
//

import UIKit

class CurvedView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 10
        layer.borderWidth = 0.5
        layer.masksToBounds = false
        layer.borderColor = UIColor.black.cgColor
    }
    

}
