//
//  MyFavouratesVC.swift
//  Login
//
//  Created by George on 25/01/2018.
//  Copyright © 2018 George Woolley. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class MyFavouratesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var rentalsArray = [Rental]()
    var myFavouates = [Rental]()
    
    
    @IBOutlet weak var myFavouratesTableView: UITableView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return myFavouates.count
     
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let myFavourateRental = myFavouates[indexPath.row]
        if let cell = myFavouratesTableView.dequeueReusableCell(withIdentifier: "favCell") as? MyFavouratesCell {
            cell.configureCell(rental: myFavourateRental)
            return cell
        } else {
            return MyFavouratesCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Allow deletion of favourate from Firebase and view
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            if let postID = myFavouates[indexPath.row].postID {
            let refFavourate = DataService.ds.DBCurrentUser.child("MyFavourates")
          
            refFavourate.child(postID).removeValue()

            }
            // remove the item from the data model
            myFavouates.remove(at: indexPath.row)
            // delete the table view row
            tableView.deleteRows(at: [indexPath], with: .fade)

        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            if let destination = segue.destination as? DetailVC, let value = myFavouratesTableView.indexPathForSelectedRow?.row {
               
                if let userID = myFavouates[value].userID {
                    destination.userID = userID
                }
                if let bond = myFavouates[value].bond {
                    destination.bond = bond
                }
                if let dateAval = myFavouates[value].dateAval {
                    destination.dateAval = dateAval
                }
                if let petPolicy = myFavouates[value].pets {
                    destination.pets = petPolicy
                }
                if let pricePolicy = myFavouates[value].price {
                    destination.rent = pricePolicy
                }
                if let rentitle = myFavouates[value].title {
                    destination.rentalTitle = rentitle
                }
                if let imageURL = myFavouates[value].imageURL {
                    destination.imageURL = imageURL
                }
                if let rentalDescription = myFavouates[value].description {
                    destination.des = rentalDescription
                }
                if let rentalType = myFavouates[value].rentalType {
                    destination.rentalType = rentalType
                }
                if let streetName = myFavouates[value].streetName {
                    destination.streetName = streetName
                }
                if let cityName = myFavouates[value].city {
                    destination.city = cityName
                }
                if let postcode = myFavouates[value].postcode {
                    destination.postcode = postcode
                }
                if let postID = myFavouates[value].postID {
                    destination.postID = postID
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toDetailVC", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myFavouratesTableView.delegate = self
        myFavouratesTableView.dataSource = self
  
        self.myFavouratesTableView.allowsMultipleSelectionDuringEditing = false
        
        DataService.ds.DBrefRentals.observe(.value) { (snapshot) in
            
            self.rentalsArray = []
            
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    if let dicOfRentals = snap.value as? Dictionary<String,AnyObject> {
                        
                        let key = snap.key
                        
                        let rental = Rental(postID: key, userData: dicOfRentals)
                        
                        
                        self.rentalsArray.append(rental)
                    }
                }
                self.myFavouratesTableView.reloadData()
            }
            
            DataService.ds.DBCurrentUser.child("MyFavourates").observe(.value) { (snapshot) in
                
                self.myFavouates = []
                
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                    for snap in snapshots {
                   
                            
                            
                            for rental in self.rentalsArray {
                                if rental.postID == snap.key {
                                    self.myFavouates.append(rental as Rental)
                                    
                                    
                                }
                            }
                            
                        
                    }
                    self.myFavouratesTableView.reloadData()
                }
                
                
            }
            
            
        }


    }

}

