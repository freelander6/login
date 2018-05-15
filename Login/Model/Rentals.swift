//
//  File.swift
//  Login
//
//  Created by George Woolley on 07/11/2017.
//  Copyright © 2017 George Woolley. All rights reserved.
//

import Foundation
import Firebase

class Rental {
    

    
    private var _title: String!
    private var _price: String!
    private var _rentalType: String!
    private var _bond: String!
    private var _rentalPeriod: String!
    private var _pets: String!
    private var _description: String!
    private var _postID: String!
    private var _userID: String!
    private var _furnished: String!
    private var _bills: String!
    private var _views = 0
    private var _imageOneUrl: String!
    private var _imageTwoUrl: String!
    private var _imageThreeUrl: String!
    private var _imageFourUrl: String!
    private var _long : Double!
    private var _lat: Double!

 
    private var _postRef: DatabaseReference!
    
    var title: String? {
        return _title
    }
    
    
    var price: String? {
        return _price
    }
    
    var rentalType: String? {
        return _rentalType
    }
    
    var bond: String? {
        return _bond
    }
    
    var rentalPeriod: String? {
        return _rentalPeriod
    }
    
    var pets: String? {
        return _pets
    }
    
    var description: String? {
        return _description
    }
    
    var postID: String? {
        return _postID
    }
    
    var userID: String? {
        return _userID
    }
    
    var furnished: String? {
        return _furnished
    }
    var bills: String? {
        return _bills
    }
    
    var views: Int? {
        return _views
    }
    
    var imageOneUrl: String? {
        return _imageOneUrl
    }
    var imageTwoUrl: String? {
        return _imageTwoUrl
    }
    var imageThreeUrl: String? {
        return _imageThreeUrl
    }
    var imageFourUrl: String? {
        return _imageFourUrl
    }
    
    var long: Double? {
        return _long
    }
    
    var lat: Double? {
        return _lat
    }
    

    
 
    
    init(title: String, price: String, rentalType: String, bond: String, rentalPeriod: String, pets: String, description: String, furnished: String, bills: String, views: Int, imageOneUrl: String, imageTwoUrl: String, imageThreeUrl: String , imageFourUrl: String, long: Double, lat: Double) {
        
        self._title = title
        self._price = price
        self._rentalType = rentalType
        self._bond = bond
        self._rentalPeriod = rentalPeriod
        self._pets = pets
        self._description = description
        self._furnished = furnished
        self._bills = bills
        self._views = views
        self._imageOneUrl = imageOneUrl
        self._imageTwoUrl = imageTwoUrl
        self._imageThreeUrl = imageThreeUrl
        self._imageFourUrl = imageFourUrl
        self._long = long
        self._lat = lat
      
    }
    
    init(postID: String, userData: Dictionary<String, AnyObject>) {
        
        self._postID = postID
        
        if let title = userData["title"] as? String {
            self._title = title
        }
        
        if let price = userData["price"] as? String {
            self._price = price
        }
        
        if let rentalType = userData["type"] as? String {
            self._rentalType = rentalType
        }
        
        if let bond = userData["bond"] as? String {
            self._bond  = bond
        }
        
        if let rentalPeriod = userData["rentalPeriod"] as? String {
            self._rentalPeriod = rentalPeriod
        }
        
        if let pets = userData["pets"] as? String {
            self._pets = pets
        }
        
        if let description = userData["description"] as? String {
            self._description = description
        }
        
        if let userID = userData["userID"] as? String {
            self._userID = userID
        }
        
        if let furnished = userData["furnished"] as? String {
            self._furnished = furnished
        }
        if let bills = userData["bills"] as? String {
            self._bills = bills
        }
        
        if let views = userData["views"] as? Int {
            self._views = views
        }
        
        if let imageOneUrl = userData["image1"] as? String {
            self._imageOneUrl = imageOneUrl
        }
        if let imageTwoUrl = userData["image2"] as? String {
            self._imageTwoUrl = imageTwoUrl
        }
        if let imageThreeUrl = userData["image3"] as? String {
            self._imageThreeUrl = imageThreeUrl
        }
        if let imageFourUrl = userData["image4"] as? String {
            self._imageFourUrl = imageFourUrl
        }
        
        
        if let long = userData["long"] as? Double {
            self._long = long
        }
        if let lat = userData["lat"] as? Double {
            self._lat = lat
        }
  
        
      
    }
    
    func incrimentViews() {
        self._views += 1
    }
    
   
}


