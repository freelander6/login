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
import HidingNavigationBar


class RentalTableViewVC: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    var rentalsArray = [Rental]()
    var filteredArrary = [Rental]()
    var myRentals = [String]()

    var isFilterEnabled: Bool? 
    var filterByPrice: Float?
    var filteredRentalTypes: Set<String>?
    var filteredFurnishedType: Set<String>?
    var filteredBillType: Set<String>?
    var filteredPetPolicy: Set<String>?
  
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var hidingBarMangar: HidingNavigationBarManager?
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            let destination = segue.destination as? DetailVC
            let value = tableView.indexPathForSelectedRow?.row
            
            if filteredArrary.count != 0 {
                
                destination?.emailAdress = filteredArrary[value!].email!
                destination?.bond = filteredArrary[value!].bond!
                destination?.dateAval = filteredArrary[value!].dateAval!
                destination?.pets = filteredArrary[value!].pets!
                destination?.rent = filteredArrary[value!].price!
                destination?.rentalTitle = filteredArrary[value!].title!
                destination?.imageURL = filteredArrary[value!].imageURL!
                destination?.des = filteredArrary[value!].description!
                destination?.rentalType = filteredArrary[value!].rentalType!
                destination?.streetName = filteredArrary[value!].streetName!
                destination?.city = filteredArrary[value!].city!
                destination?.postcode = filteredArrary[value!].postcode!
            } else {
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
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isFilterEnabled == true {
            return filteredArrary.count
        } else {
            return rentalsArray.count
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
      var rental = rentalsArray[indexPath.row]
        
//        if  indexPath.row < self.filteredArrary.count  {
//            rental = filteredArrary[indexPath.row]
//        }
       
        if isFilterEnabled == true {
            rental = filteredArrary[indexPath.row]
        }
        

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hidingBarMangar?.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        hidingBarMangar?.viewDidLayoutSubviews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hidingBarMangar?.viewWillDisappear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       
        tableView.dataSource = self
        tableView.dataSource = self
        
        //Firebase observer
        DataService.ds.DBrefRentals.observe(.value) { (snapshot) in
            
            self.rentalsArray = []
            self.filteredArrary = []
            
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    if let dicOfRentals = snap.value as? Dictionary<String,AnyObject> {
                        
                        let key = snap.key
                        
                        let rental = Rental(postID: key, userData: dicOfRentals)
                        self.rentalsArray.append(rental)
                        
                        if self.filterByPrice != nil && self.filteredRentalTypes != nil {
                            self.applyFilters(rental: rental)
                        }

                     
                        
                    }
                }
                self.tableView.reloadData()
            }
        
        
        
        }
        addHidingBar()
        
        
    }
    
    func filterByPrice(rental: Rental) {
        let priceAsFloat = (rental.price! as NSString).floatValue
        if self.filterByPrice! >= priceAsFloat {
            self.filteredArrary.append(rental)
        }
    }
    
    func applyFilters(rental: Rental) {
        let priceAsFloat = (rental.price! as NSString).floatValue
        for rentals in self.filteredRentalTypes! {
            for furn in self.filteredFurnishedType! {
                for pet in self.filteredPetPolicy! {
            if rental.rentalType == rentals, self.filterByPrice! >= priceAsFloat, rental.furnished == furn, rental.pets == pet {
                print("******hh\(String(describing: self.filteredRentalTypes))")
                self.filteredArrary.append(rental)
                    }
                }
            }
        }
    }
    
    
   

    
    
    override func viewDidAppear(_ animated: Bool) {
        print("**********\(String(describing: filterByPrice)))")
    }
    
 
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        rentalsArray[indexPath.row].incrimentViews()
       
        let postViewsToFB = DataService.ds.DBrefRentals.child(rentalsArray[indexPath.row].postID!)
        
        postViewsToFB.child("views").setValue(rentalsArray[indexPath.row].views)
        
         performSegue(withIdentifier: "toDetailVC" , sender: nil)
    }
    


    

    func addHidingBar() {
      
        
        let extensionView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 40))
        extensionView.layer.borderColor = UIColor.lightGray.cgColor
        extensionView.layer.borderWidth = 1
        extensionView.backgroundColor = UIColor(white: 230/255, alpha: 1)
        /*let label = UILabel(frame: extensionView.frame)
        label.text = "Extension View"
        label.textAlignment = NSTextAlignment.center
        extensionView.addSubview(label) */
        
        let btn = UIButton(frame: CGRect(x: 20, y: 15, width: 75, height: 10))
        btn.setTitle("Filter", for: .normal)
        let btnColour = UIColor(displayP3Red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
        btn.setTitleColor(btnColour, for: .normal)
        btn.titleLabel?.font = headerFont
        btn.addTarget(self, action: #selector(filterBtnPressed), for: .touchUpInside)
        
        extensionView.addSubview(btn)
        hidingBarMangar = HidingNavigationBarManager(viewController: self, scrollView: tableView)
        hidingBarMangar?.addExtensionView(extensionView)
        
    }
    
    @objc func filterBtnPressed() {
        performSegue(withIdentifier: "toFilterVC", sender: nil)
    }
    
    
}
