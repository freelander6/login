//
//  RentalCell.swift
//  Login
//
//  Created by George Woolley on 02/12/2017.
//  Copyright © 2017 George Woolley. All rights reserved.
//

import UIKit

class RentalCell: UITableViewCell {
    
    var rental: Rental!
    
    @IBOutlet weak var rentalTitleLbl: UILabel!
    @IBOutlet weak var rentalPriceLbl: UILabel!
    @IBOutlet weak var rentalImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(rental: Rental) {
        self.rental = rental
        
        self.rentalTitleLbl.text = rental.title 
        self.rentalPriceLbl.text = "$\(rental.price) Per Week"
    }

}
