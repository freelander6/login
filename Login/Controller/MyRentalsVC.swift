//
//  MyRentalsVC.swift
//  Login
//
//  Created by George on 03/01/2018.
//  Copyright © 2018 George Woolley. All rights reserved.
//

import UIKit
import Firebase

class MyRentalsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var rentalsArray = [Rental]()
    var myRentals = [Rental]()
    

    @IBOutlet weak var myRentalsTableView: UITableView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myRentals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let myrental = myRentals[indexPath.row]
        if let cell = myRentalsTableView.dequeueReusableCell(withIdentifier: "cell") as? MyRentalCell {
            cell.configureCell(rental: myrental)
            return cell
        } else {
            return MyRentalCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        // Delete items on swipe
        
        
        if editingStyle == .delete {
            let postID = myRentals[indexPath.row].postID
           // let imageID = myRentals[indexPath.row].ImageID
            let refRental = DataService.ds.DBrefRentals
            let refUsers = DataService.ds.DBCurrentUser.child("MyRentals")
            let refFBstorage = DataService.ds.StorageREF
            refRental.child(postID!).removeValue()
            refUsers.child(postID!).removeValue()
            refFBstorage.child("rental_images")
            
            //Remove images from Storage
            
            if let imageOneUrl = myRentals[indexPath.row].imageOneUrl {
                let storageRef = Storage.storage().reference(forURL: imageOneUrl)
                storageRef.delete(completion: { (error) in
                    if error != nil {
                        //error deleting
                    } else {
                        print("File deleted")
                    }
                })
            }
            
            if let imageTwoUrl = myRentals[indexPath.row].imageTwoUrl {
                let storageRef = Storage.storage().reference(forURL: imageTwoUrl)
                storageRef.delete(completion: { (error) in
                    if error != nil {
                        //error deleting
                    } else {
                        print("File deleted")
                    }
                })
            }
            
            if let imageThreeUrl = myRentals[indexPath.row].imageThreeUrl {
                let storageRef = Storage.storage().reference(forURL: imageThreeUrl)
                storageRef.delete(completion: { (error) in
                    if error != nil {
                        //error deleting
                    } else {
                        print("File deleted")
                    }
                })
            }
            
            if let imageFourUrl = myRentals[indexPath.row].imageFourUrl {
                let storageRef = Storage.storage().reference(forURL: imageFourUrl)
                storageRef.delete(completion: { (error) in
                    if error != nil {
                        //error deleting
                    } else {
                        print("File deleted")
                    }
                })
            }

    
            
            // remove the item from the data model
            myRentals.remove(at: indexPath.row)
            
            
           
            
            // delete the table view row
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } 
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myRentalsTableView.delegate = self
        myRentalsTableView.dataSource = self
        
        self.myRentalsTableView.allowsMultipleSelectionDuringEditing = false
            
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
                self.myRentalsTableView.reloadData()
            }
            
            DataService.ds.DBCurrentUser.child("MyRentals").observe(.value) { (snapshot) in
                
                self.myRentals = []
                
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                    for snap in snapshots {
                        if let value = snap.value {
                            
                            for rental in self.rentalsArray {
                                if rental.postID == value as? String {
                                    self.myRentals.append(rental as Rental)
                                    
                                    
                                }
                            }
                            
                        }
                    }
                    self.myRentalsTableView.reloadData()
                }
                
                
            }
            
            
        }

        
        // Dispose of any resources that can be recreated.
    }
    
    
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

