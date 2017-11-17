//
//  RentalTableViewVC.swift
//  Login
//
//  Created by George Woolley on 08/11/2017.
//  Copyright © 2017 George Woolley. All rights reserved.
//

import UIKit
import FirebaseDatabase


class RentalTableViewVC: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var rentalImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var rentalTitle: UILabel!
    @IBOutlet weak var rentalPrice: UILabel!
    
    
    var rentalsObject = RentalObjects()
    var databaseRef:DatabaseReference?
    var handle: DatabaseHandle?
    
    var arrayOfTitles = [String?]()
    var arrayOfBond = [String?]()
    var arrayOfDateAval = [String?]()
    var arrayOfDes = [String?]()
    var arrayOfLocation = [String?]()
    var arrayOfPets = [String?]()
    var arrayOfPrice = [String?]()
    var arrayOfRentalType = [String?]()
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return rentalsObject.title.count
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        
        
        
        
        cell.textLabel?.text = ("Title: \(rentalsObject.title[indexPath.row]), DateAval: \(rentalsObject.dateAval[indexPath.row])")
        
        
        
        return cell
    }
    
    
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.dataSource = self
        
        
        databaseRef = Database.database().reference().child("Rentals")
        databaseRef?.observe(.childAdded, with: { (snapshot) in
            
            
            if let dictonary = snapshot.value as? [String: AnyObject] {
                
                print(snapshot)
                
                
                
                
                switch snapshot.key {
                    
                    
                case "bond" :
                    _ =  dictonary.map{self.rentalsObject.bond.append(($0.value as? String)!)}
                    //      print(self.arrayOfBond)
                    
                    
                case "dateAval" :
                    _ =  dictonary.map{self.rentalsObject.dateAval.append(($0.value as? String)!)}
                    
                    
                case "description" :
                    _ =  dictonary.map{self.rentalsObject.descripton.append(($0.value as? String)!)}
                    
                    
                case "location" :
                    _ =  dictonary.map{self.rentalsObject.location.append(($0.value as? String)!)}
                    
                    
                case "pets" :
                    _ =  dictonary.map{self.rentalsObject.pets.append(($0.value as? String)!)}
                    
                    
                    
                case "price" :
                    _ =  dictonary.map{self.rentalsObject.price.append(($0.value as? String)!)}
                    
                    
                case "rentalType" :
                    _ =  dictonary.map{self.rentalsObject.rentalType.append(($0.value as? String)!)}
                    
                    
                case "title" :
                    _ =  dictonary.map{self.rentalsObject.title.append(($0.value as? String)!)}
                    print(self.rentalsObject.title)
                    
                    
                    //       _ =  dictonary.map{self.arrayOfTitles.append($0.value as? String)}
                    //    print(self.arrayOfTitles)
                    
                default:
                    break
                    
                }
                
            }
            
            
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
            
            
        })
        
    }
    
}
