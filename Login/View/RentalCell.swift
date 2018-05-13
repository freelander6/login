//
//  RentalCell.swift
//  Login
//
//  Created by George Woolley on 02/12/2017.
//  Copyright © 2017 George Woolley. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import MessageUI


class RentalCell: UITableViewCell, MFMailComposeViewControllerDelegate {
    
    var rental: Rental!
    
    
    
    @IBOutlet weak var rentalTitleLbl: UILabel!
    @IBOutlet weak var rentalPriceLbl: UILabel!
    @IBOutlet weak var rentalTypeLbl: UILabel!
    @IBOutlet weak var bondLbl: UILabel!
    @IBOutlet weak var dateAvalLbl: UILabel!
    @IBOutlet weak var furnished: UILabel!
    
    var indicator = UIActivityIndicatorView()
    var hasImage: Bool?
    
    @IBOutlet weak var rentalImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
 
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configureCell(rental: Rental, image: UIImage?) {
        
        //Add activity inditcator
        if hasImage != true {
            activityIndicator()
            indicator.startAnimating()
            indicator.backgroundColor = UIColor.clear
        }
       
        
        //Initialiase outlets 
        self.rental = rental
        self.rentalTitleLbl.text = rental.title
        self.rentalPriceLbl.text = "$\(rental.price!) p/w"
        self.rentalTypeLbl.text = rental.rentalType
        self.bondLbl.text = rental.bond
        self.dateAvalLbl.text = rental.rentalPeriod
        self.furnished.text = rental.furnished
      //  self.petsLbl.text = rental.pets

    
        if image != nil {
            //Image already in cache
            //Stop indicator
            self.indicator.stopAnimating()
            self.indicator.hidesWhenStopped = true
            self.rentalImage.image = image
        } else {
            // download image from Firebase
          
            
            if let image = rental.imageOneUrl {
                let ref = Storage.storage().reference(forURL: image)
                
                ref.getData(maxSize:  2 * 1024 * 1024, completion: { (data, error) in
                    if error != nil {
                        print("An error has occured downloading image")
                    } else {
                        print("Image downloaded")
                        if let imageData = data {
                            if let img = UIImage(data: imageData) {
                                self.rentalImage.image = img
                                RentalTableViewVC.imageCache.setObject(img, forKey: rental.imageOneUrl! as NSString)
                                //Stop indicator
                                self.indicator.stopAnimating()
                                self.indicator.hidesWhenStopped = true
                                self.hasImage = true
                            }
                            
                        }
                    }
                })
            }
            
        
            
            
        }
        
    }
    
    
    //Activity display/Loading bar
    func activityIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
      //  indicator.center = self.view.center
        //self.view.addSubview(indicator)
        indicator.center = CGPoint(x: 185, y: 200)
        addSubview(indicator)
    }
    
    
    

    

}
