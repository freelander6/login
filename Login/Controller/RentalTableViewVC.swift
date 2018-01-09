//
//  RentalTableViewVC.swift
//  Login
//
//  Created by George Woolley on 08/11/2017.
//  Copyright © 2017 George Woolley. All rights reserved.
//
import UIKit
import FirebaseDatabase
import MessageUI
import SwiftKeychainWrapper


class RentalTableViewVC: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    var rentalsArray = [Rental]()
    var index = ""
    var myRentals = [String]()

  
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier ==  "toEmailVC" {
//            let destination = segue.destination as? EmailVC,
//            passIndex = tableView.indexPathsForSelectedRow. {
//                destination?.emailAdress = rentalsArray[passIndex]
//            }
//        }
//    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            let destination = segue.destination as? DetailVC
            let value = tableView.indexPathForSelectedRow?.row
            
            
            destination?.emailAdress = rentalsArray[value!].email!
            destination?.bond = rentalsArray[value!].bond!
            destination?.dateAval = rentalsArray[value!].dateAval!
            destination?.pets = rentalsArray[value!].pets!
            destination?.rent = rentalsArray[value!].price!
            destination?.rentalTitle = rentalsArray[value!].title!
            destination?.imageURL = rentalsArray[value!].imageURL!
            destination?.des = rentalsArray[value!].description!
            destination?.rentalType = rentalsArray[value!].rentalType!
            destination?.streetName = rentalsArray[value!].streetName!
            destination?.city = rentalsArray[value!].city!
            destination?.postcode = rentalsArray[value!].postcode!
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rentalsArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
      let rental = rentalsArray[indexPath.row]
        

        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? RentalCell {




            var rentalImage = ""

            if rental.imageURL != nil {
                rentalImage = rental.imageURL!
            }


            if let img = RentalTableViewVC.imageCache.object(forKey: rentalImage as NSString) {
                cell.configureCell(rental: rental, image: img)

                return cell
            } else {
                cell.configureCell(rental: rental, image: nil)

                return cell
            }

        } else {
            return RentalCell()
        }
   
    }
    
    
  
    
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tableView.dataSource = self
        tableView.dataSource = self
        
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
                self.tableView.reloadData()
            }
        
        
        
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        rentalsArray[indexPath.row].incrimentViews()
       
        let postViewsToFB = DataService.ds.DBrefRentals.child(rentalsArray[indexPath.row].postID!)
        
        postViewsToFB.child("views").setValue(rentalsArray[indexPath.row].views)
        
         performSegue(withIdentifier: "toDetailVC" , sender: nil)
    }
    

    @IBAction func contactBtnPressed(_ sender: Any) {
    }
    

    
    
}
