//
//  RentalTableViewVC.swift
//  Login
//
//  Created by George Woolley on 08/11/2017.
//  Copyright © 2017 George Woolley. All rights reserved.
//
import UIKit
import FirebaseDatabase


class RentalTableViewVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var rentalsArray = [Rental]()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rentalsArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
      let rental = rentalsArray[indexPath.row]
        
     
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? RentalCell {
            
          cell.configureCell(rental: rental)
            
            return cell
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
}
