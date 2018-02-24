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
    var filteredRegion: String?
    var filteredCity: String?
    var filteredPostCode: String? 
  
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var hidingBarMangar: HidingNavigationBarManager?
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            if let destination = segue.destination as? DetailVC, let value = tableView.indexPathForSelectedRow?.row{
            
           if filteredArrary.isEmpty == false {                                      // If filters are applied
            
            if let filteredUserID = filteredArrary[value].userID {
                destination.userID = filteredUserID
            }
            if let filteredBond = filteredArrary[value].bond {
                destination.bond = filteredBond
            }
            if let filteredDateAval = filteredArrary[value].dateAval {
                destination.dateAval = filteredDateAval
            }
            if let filteredPetPolicy = filteredArrary[value].pets {
                destination.pets = filteredPetPolicy
            }
            if let filteredPricePolicy = filteredArrary[value].price {
                destination.rent = filteredPricePolicy
            }
            if let filteredRentitle = filteredArrary[value].title {
                destination.rentalTitle = filteredRentitle
            }
            if let filteredImageURL = filteredArrary[value].imageURL {
                destination.imageURL = filteredImageURL
            }
            if let filteredRentDescription = filteredArrary[value].description {
                destination.des = filteredRentDescription
            }
            if let filteredRentalType = filteredArrary[value].rentalType {
                destination.rentalType = filteredRentalType
            }
            if let filteredStreetName = filteredArrary[value].streetName {
                destination.streetName = filteredStreetName
            }
            if let filteredCityName = filteredArrary[value].city {
                destination.city = filteredCityName
            }
            if let filteredPostcode = filteredArrary[value].postcode {
                destination.postcode = filteredPostcode
            }
            if let filteredPostID = filteredArrary[value].postID {
                destination.postID = filteredPostID
            }
            
           
            } else {     // No filtering if filtered array is empty
            
            if let userIDValue = rentalsArray[value].userID {
                destination.userID = userIDValue
            }
            if let bondValue = rentalsArray[value].bond{
                destination.bond = bondValue
            }
            if let dateAvalValue = rentalsArray[value].dateAval {
                destination.dateAval = dateAvalValue
            }
            if let petPolicyValue = rentalsArray[value].pets {
                destination.pets = petPolicyValue
            }
            if let priceValue = rentalsArray[value].price {
                destination.rent = priceValue
            }
            if let rentalTitleValue = rentalsArray[value].title {
                destination.rentalTitle = rentalTitleValue
            }
            if let imageURLValue = rentalsArray[value].imageURL {
                destination.imageURL = imageURLValue
            }
            if let rentalDescriptionValue = rentalsArray[value].description {
                destination.des = rentalDescriptionValue
            }
            if let rentalTypeValue = rentalsArray[value].rentalType{
                destination.rentalType = rentalTypeValue
            }
            if let streetNameValue = rentalsArray[value].streetName {
                destination.streetName = streetNameValue
            }
            if let cityNameValue = rentalsArray[value].city {
                destination.city = cityNameValue
            }
            if let postcodeValue = rentalsArray[value].postcode {
                destination.postcode = postcodeValue
            }
            if let postID = rentalsArray[value].postID {
                destination.postID = postID
            }
            
          }
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
                        
                       // if self.filterByPrice != nil && self.filteredRentalTypes != nil  {
                        if self.isFilterEnabled == true {
                            self.applyFilters(rental: rental)
                        }

                     
                        
                    }
                }
                
                DispatchQueue.main.async{
                    self.tableView.reloadData()
                }
            }
        
        
        
        }
        addHidingBar()
        
        
    }
    
    
    func applyFilters(rental: Rental) {
        
        if filterByPrice == nil {
            filterByPrice = 20000
        }
        if filteredPostCode == nil {
            filteredPostCode = "All"
        }
        if filteredRegion == nil {
            filteredRegion = "All"
        }
        if filteredCity == nil {
            filteredCity = "All"
        }
        if filteredRentalTypes == nil {
            filteredRentalTypes = ["Entire house", "Room in a shared house", "Room share", "Flat", "Apartment", "Other"]
        }
        if filteredFurnishedType == nil {
            filteredFurnishedType = ["Fully furnished", "Partly furnished", "Appliances only", "Not furnished"]
        }
        if filteredPetPolicy == nil {
            filteredPetPolicy = ["Pets allowed", "No pets allowed"]
        }
        
        
        if let priceFilter = self.filterByPrice, let regionFilter = filteredRegion, let rentalTypefilter = filteredRentalTypes, let filteredFurnishedType = filteredFurnishedType, let filteredPetPolicy = filteredPetPolicy, let filteredCity = filteredCity, let filteredPostcode = filteredPostCode {
        
        let priceAsFloat = (rental.price! as NSString).floatValue
        for rentals in rentalTypefilter {
            for furn in filteredFurnishedType {
                for pet in filteredPetPolicy {
            if rental.rentalType == rentals, priceFilter >= priceAsFloat, rental.furnished == furn, rental.pets == pet, rental.region == regionFilter || regionFilter == "All" , rental.city == filteredCity || filteredCity == "All", rental.postcode == filteredPostcode || filteredPostcode == "All"{
               // print("******hh\(String(describing: self.filteredRentalTypes))")
                self.filteredArrary.append(rental)
                    }
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
        
        let btn = UIButton(frame: CGRect(x: 275, y: 15, width: 75, height: 10))
        btn.setTitle("Filter", for: .normal)
        let btnColour = UIColor(displayP3Red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
        btn.setTitleColor(btnColour, for: .normal)
        btn.titleLabel?.font = headerFont
        btn.addTarget(self, action: #selector(filterBtnPressed), for: .touchUpInside)
        
        let menuBtn = UIButton(frame: CGRect(x: 20, y: 15, width: 75, height: 10))
        menuBtn.setTitle("Menu", for: .normal)
       
        menuBtn.setTitleColor(btnColour, for: .normal)
        menuBtn.titleLabel?.font = headerFont
        menuBtn.addTarget(self, action: #selector(menuBtnPressed), for: .touchUpInside)
        
        let locationBtn = UIButton(frame: CGRect(x: 150, y: 15, width: 75, height: 10))
        locationBtn.setTitle("Location", for: .normal)
        
        locationBtn.setTitleColor(btnColour, for: .normal)
        locationBtn.titleLabel?.font = headerFont
        locationBtn.addTarget(self, action: #selector(locationBtnPressed), for: .touchUpInside)
        
        
        
        extensionView.addSubview(btn)
        extensionView.addSubview(menuBtn)
        extensionView.addSubview(locationBtn)
        hidingBarMangar = HidingNavigationBarManager(viewController: self, scrollView: tableView)
        hidingBarMangar?.addExtensionView(extensionView)
        
    }
    
    @objc func filterBtnPressed() {
        performSegue(withIdentifier: "toApplyFiltersVC", sender: nil)
    }
    @objc func menuBtnPressed() {
        performSegue(withIdentifier: "toSideMenu", sender: nil)
    }
    
    @objc func locationBtnPressed() {
        
    }
    
}
