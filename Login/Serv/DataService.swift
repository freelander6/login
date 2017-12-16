//
//  DataService.swift
//  Login
//
//  Created by George Woolley on 02/12/2017.
//  Copyright © 2017 George Woolley. All rights reserved.
//

import Foundation
import Firebase


let DB = Database.database().reference()
let STORAGE = Storage.storage().reference()

class DataService {
    
    static let ds = DataService()
    
    //dba references
    private var _DBAref = DB
    private var _DBRrefRentals = DB.child("Rentals")
    private var _DBRrefUsers = DB.child("Users")
    private var _DBrefUserRentals = DB.child("Users").child("Rentals")
    
    //firebase storage ref
    private var _StorageREF = STORAGE.child("rental_images")
    
    var StorageREF : StorageReference {
        return _StorageREF
    }
    
    var DBAref: DatabaseReference {
        return _DBAref
    }
    
    var DBrefRentals: DatabaseReference {
        return _DBRrefRentals
    }
    
    var DBrefUsers: DatabaseReference {
        return _DBRrefUsers
    }
    
    var DBrefUserRentals: DatabaseReference {
        return _DBrefUserRentals
    }
    
    func createFirebaseDBUser(uid: String, users: Dictionary<String, String>) {
        DBrefUsers.child(uid).updateChildValues(users)
    }
    
    
}