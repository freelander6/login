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
    private var _imgURL: String!
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
    private var _ImageID: String!
    private var _streetName: String!
    private var _city: String!
    private var _postcode:String!
    private var _region: String!
 
    private var _postRef: DatabaseReference!
    
    var title: String? {
        return _title
    }
    
    var imageURL: String? {
        return _imgURL
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
    
    var ImageID: String? {
        return _ImageID
    }
    
    var streetName: String? {
        return _streetName
    }
    
    var city: String? {
        return _city
    }
    
    var postcode: String? {
        return _postcode
    }
    
    var region: String? {
        return _region
    }
    
 
    
    init(title: String, imageURL: String, price: String, rentalType: String, bond: String, rentalPeriod: String, pets: String, description: String, furnished: String, bills: String, views: Int, ImageID: String, streetName: String, city: String, postcode: String, region: String) {
        
        self._title = title
        self._imgURL = imageURL
        self._price = price
        self._rentalType = rentalType
        self._bond = bond
        self._rentalPeriod = rentalPeriod
        self._pets = pets
        self._description = description
        self._furnished = furnished
        self._bills = bills
        self._views = views
        self._ImageID = ImageID
        self._streetName = streetName
        self._city = city
        self._postcode = postcode
        self._region = region
      
    }
    
    init(postID: String, userData: Dictionary<String, AnyObject>) {
        
        self._postID = postID
        
        if let title = userData["title"] as? String {
            self._title = title
        }
        
        if let imageURL = userData["imageURL"] as? String {
            self._imgURL = imageURL
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
        
        if let imageID = userData["ImageID"] as? String {
            self._ImageID = imageID
        }
        
        if let streetName = userData["street"] as? String {
            self._streetName = streetName
        }
        
        if let city = userData["city"] as? String {
            self._city = city
        }
        
        if let postcode = userData["postcode"] as? String {
            self._postcode = postcode
        }
        
        if let region = userData["region"] as? String {
            self._region = region
        }
        
      
    }
    
    func incrimentViews() {
        self._views += 1
    }
    
   
}


