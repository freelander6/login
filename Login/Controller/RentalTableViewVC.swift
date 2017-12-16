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


class RentalTableViewVC: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    var rentalsArray = [Rental]()
    var currentEmail = ""
    var index = ""

  
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
        if segue.identifier == "toEmailVC" {
            let destination = segue.destination as? EmailVC
            let value = tableView.indexPathForSelectedRow?.row
            
            
            destination?.emailAdress = rentalsArray[value!].email!
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
            
            if cell.emailField.text != nil {
                currentEmail = cell.emailField.text!
            }
            
          
            
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
            
           // self.posts = []
            
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
    
    

    @IBAction func contactBtnPressed(_ sender: Any) {
    }
    

    
    
}
