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
    private var _postID: String!
    private var _postRef: DatabaseReference!
    
    var title: String? {
        return _title
    }
    
    var imageURL: String? {
        return _imgURL
    }
    
    var price: String {
        return _price
    }
    
    var postID: String {
        return _postID
    }
    
    init(title: String, imageURL: String, price: String) {
        
        self._title = title
        self._imgURL = imageURL
        self._price = price
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
        
      
        
    }
    
   
}


