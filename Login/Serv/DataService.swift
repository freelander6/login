//
//  DataService.swift
//  Login
//
//  Created by George Woolley on 02/12/2017.
//  Copyright © 2017 George Woolley. All rights reserved.
//

import Foundation
import Firebase
import SwiftKeychainWrapper


let DB = Database.database().reference()
let STORAGE = Storage.storage().reference()

class DataService {
    
    static let ds = DataService()
    
    //dba references
    private var _DBAref = DB
    private var _DBRrefRentals = DB.child("Rentals")
    private var _DBRrefUsers = DB.child("Users")
    private var _DBRefMyRentals = DB.child("Users").child("MyRentals")
    private var _DBRefThreads = DB.child("Threads")

    
    //firebase storage ref
    private var _StorageREF = STORAGE.child("rental_images")
    private var _StorageProfile = STORAGE.child("ProfileImages")
    
    var StorageREF : StorageReference {
        return _StorageREF
    }
    var StorageProfile: StorageReference {
        return _StorageProfile
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
    
    var DBrefThreads : DatabaseReference {
        return _DBRefThreads
    }
    
    
    var DBCurrentUser: DatabaseReference {
        let uid: String? = KeychainWrapper.standard.string(forKey: "uid")
        let currentUser = DBrefUsers.child(uid!)
        return currentUser
        
    }
    
    var DBMyRetals: DatabaseReference {
        return _DBRefMyRentals
    }
    
    func createFirebaseDBUser(uid: String, users: Dictionary<String, String>) {
        DBrefUsers.child(uid).child("MyDetails").updateChildValues(users)
    }
    
    
}
