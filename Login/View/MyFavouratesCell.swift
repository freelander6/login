//
//  MyFavouratesCell.swift
//  Login
//
//  Created by George on 25/01/2018.
//  Copyright © 2018 George Woolley. All rights reserved.
//

import UIKit
import Firebase 

class MyFavouratesCell: UITableViewCell {

    var rental: Rental?
    

    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var rentalImage: UIImageView!
    
    
    
    func configureCell(rental : Rental, image : UIImage?) {
        
        if let title = rental.title {
            self.title.text = title
        }

        if image != nil {
            //Image already in cache
            self.rentalImage.image = image
        } else {
            // download image from Firebase
            let ref = Storage.storage().reference(forURL: rental.imageOneUrl!)
            ref.getData(maxSize:  2 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print("An error has occured downloading image")
                } else {
                    print("Image downloaded")
                    if let imageData = data {
                        if let img = UIImage(data: imageData) {
                            self.rentalImage.image = img
                            RentalTableViewVC.imageCache.setObject(img, forKey: rental.imageOneUrl! as NSString)
                        }
                    }
                }
            })
            
            
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
