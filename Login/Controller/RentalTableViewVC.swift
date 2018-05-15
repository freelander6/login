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
import LocationPickerViewController
import DropDown
import CFAlertViewController


class RentalTableViewVC: UIViewController, UITableViewDataSource, UITableViewDelegate  {
   
    //User defaults to save location
    let defaultLocation = UserDefaults.standard
    
    var selectedLocation: CLLocation {
        let lat = defaultLocation.double(forKey: "lat")
        let long = defaultLocation.double(forKey: "long")
        let loc = CLLocation(latitude: lat, longitude: long)
        return loc
    }
    
    var allowedDistance: Double {
        return defaultLocation.double(forKey: "distance")
    }
    
    let typeDro = DropDown()
    
    var rentalsArray = [Rental]()
    var filteredArrary = [Rental]()
    var filteredLocationArrary = [Rental]()
    
    var myRentals = [String]()
    
    var imageURLS = [String]()

    var isFilterEnabled: Bool?
    var filterByMinPrice: Float?
    var filterByMaxPrice: Float?
    var filteredRentalTypes: String?
    var filteredFurnishedType: String?
    var filteredBillType: String?
    var filteredPetPolicy: String?
    var filteredRentalPeriod: String?
    var filteredRegion: String?
    var filteredCity: String?
    var filteredPostCode: String?
    var filteredBond: String?
    
//    var location: CLLocation?
    
  
   var indicator = UIActivityIndicatorView()
    
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
            if let filteredRentalPeriod = filteredArrary[value].rentalPeriod {
                destination.rentalPeriod = filteredRentalPeriod
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
            if let filteredImageOneUrl = filteredArrary[value].imageOneUrl {
                destination.imageOneUrl = filteredImageOneUrl
            }
            if let filteredImageTwoUrl = filteredArrary[value].imageTwoUrl {
                destination.imageTwoUrl = filteredImageTwoUrl
            }
            if let filteredImageThreeUrl = filteredArrary[value].imageThreeUrl {
                destination.imageThreeUrl = filteredImageThreeUrl
            }
            if let filteredImageFourUrl = filteredArrary[value].imageFourUrl {
                destination.imageFourUrl = filteredImageFourUrl
            }
            if let filteredRentDescription = filteredArrary[value].description {
                destination.des = filteredRentDescription
            }
            if let filteredRentalType = filteredArrary[value].rentalType {
                destination.rentalType = filteredRentalType
            }
            if let filteredLat = filteredArrary[value].lat {
                destination.lat = filteredLat
            }
            if let filteredLong = filteredArrary[value].long {
                destination.long  = filteredLong
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
            if let rentalPeriodValue = rentalsArray[value].rentalPeriod {
                destination.rentalPeriod = rentalPeriodValue
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
            if let imageOneUrl = rentalsArray[value].imageOneUrl {
                destination.imageOneUrl = imageOneUrl
            }
            if let imageTwoUrl = rentalsArray[value].imageTwoUrl {
                destination.imageTwoUrl = imageTwoUrl
            }
            if let imageThreeUrl = rentalsArray[value].imageThreeUrl {
                destination.imageThreeUrl = imageThreeUrl
            }
            if let imageFourUrl = rentalsArray[value].imageFourUrl {
                destination.imageFourUrl = imageFourUrl
            }
            if let rentalDescriptionValue = rentalsArray[value].description {
                destination.des = rentalDescriptionValue
            }
            if let rentalTypeValue = rentalsArray[value].rentalType{
                destination.rentalType = rentalTypeValue
            }
       
            if let latValue = rentalsArray[value].lat {
                destination.lat = latValue
            }
            if let longValue = rentalsArray[value].long {
                destination.long = longValue
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

        
        if isFilterEnabled == true {
            
            rental = filteredArrary[indexPath.row]
        }
        

        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? RentalCell {

            
            
            
            
            var rentalImage = ""

            if rental.imageOneUrl != nil {
                rentalImage = rental.imageOneUrl!
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
        
        addHidingBar()
        
        
        
        self.rentalsArray = []
        self.filteredArrary = []
       
        tableView.dataSource = self
        tableView.dataSource = self
        
        if userDefaultExist(key: "name") == false {
            addAlertViewIfLocationNotSet()
        }
      
     
        
    }
    
    
    
    
    func applyFilters(rental: Rental) {
        let priceAsFloat = (rental.price! as NSString).floatValue
        if let maxPrice = filterByMaxPrice, let minPrice = filterByMinPrice {
            if priceAsFloat <= maxPrice && priceAsFloat >= minPrice {
                if let type = rental.rentalType {
                    if filteredRentalTypes == type || filteredRentalTypes == nil {
                        if let period = rental.rentalPeriod {
                            if filteredRentalPeriod == period || filteredRentalPeriod == nil {
                                if let furnished = rental.furnished {
                                    if filteredFurnishedType == furnished || filteredFurnishedType == nil {
                                        if rental.bond == nil && filteredBond == "No" || rental.bond != nil && filteredBond == "Yes" || filteredBond == nil {
                                            if let bills = rental.bills {
                                                if filteredBillType == bills || filteredBillType == nil {
                                                    if let pets = rental.pets {
                                                        if filteredPetPolicy == pets || filteredPetPolicy == nil {
                                                            if let lat = rental.lat, let long = rental.long {
                                                                let rentalLocation = CLLocation(latitude: lat, longitude: long)
                                                                if rentalLocation.distance(from: selectedLocation)/1000 <= allowedDistance {
                                                                     self.filteredArrary.append(rental)
                                                                }
                                                               
                                                            }
                                                            
                                                            
                                                        }
                                                    }
                                                }
                                            }
                                            
                                        }
                                    }
                                }
                            }
                        }
                        
                    }
                }
            }
            
        }
        
    }

   
    override func viewDidAppear(_ animated: Bool) {
        activityIndicator()
        indicator.startAnimating()
        indicator.backgroundColor = UIColor.white
        
        DataService.ds.DBrefRentals.observe(.value) { (snapshot) in
            
            self.rentalsArray = []
            self.filteredArrary = []
            
            DispatchQueue.main.async {
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                    for snap in snapshots {
                        if let dicOfRentals = snap.value as? Dictionary<String,AnyObject> {
                            
                            let key = snap.key
                            
                            let rental = Rental(postID: key, userData: dicOfRentals)
                            
                            
                            
                            
                            if let rentalLong = rental.long, let rentalLat = rental.lat  {
                                let rentalLocation = CLLocation(latitude: rentalLat, longitude: rentalLong)
                                let distance = rentalLocation.distance(from: self.selectedLocation)/1000
                                print("distance: \(distance)")
                                
                                if distance <= self.allowedDistance {
                                    self.rentalsArray.append(rental)
                                } else {
                                    print("no rentals match")
                                }
                                
                            }
                            
                            
                            
                            if self.isFilterEnabled == true  {
                                self.applyFilters(rental: rental)
                            }
                            
                            
                            
                            
                            
                            
                            
                            
                        }
                    }
                    
                    DispatchQueue.main.async{
                        self.indicator.stopAnimating()
                        self.indicator.hidesWhenStopped = true
                        self.tableView.reloadData()
                    }
                }

            }
            
            
            
            
        }
        
        

    }
    
 
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        rentalsArray[indexPath.row].incrimentViews()
       
        let postViewsToFB = DataService.ds.DBrefRentals.child(rentalsArray[indexPath.row].postID!)
        
        postViewsToFB.child("views").setValue(rentalsArray[indexPath.row].views)
        
         performSegue(withIdentifier: "toDetailVC" , sender: nil)
    }
    


    func addAlertViewIfLocationNotSet() {
        
        // Create Alet View Controller
        let alertController = CFAlertViewController(title: "You've not yet set a location",
                                                    message: "Set a location to view the best results in your area      ",
                                                    textAlignment: .left,
                                                    preferredStyle: .alert,
                                                    didDismissAlertHandler: nil)
        // Create Upgrade Action
        let defaultAction = CFAlertAction(title: "Set location",
                                          style: .Default,
                                          alignment: .center,
                                          backgroundColor: UIColor(red: CGFloat(46.0 / 255.0), green: CGFloat(204.0 / 255.0), blue: CGFloat(113.0 / 255.0), alpha: CGFloat(1)),
                                          textColor: nil,
                                          handler: { (action) in
                                            
                                            print("Button with title '" + action.title! + "' tapped")
                                            self.performSegue(withIdentifier: "toLocationSelectVC", sender: nil)
        })
        
        // Add Action Button Into Alert
        alertController.addAction(defaultAction)
        
        // Present Alert View Controller
        present(alertController, animated: true, completion: nil)
        
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
        
        let btn = UIButton(frame: CGRect(x: 275, y: -5, width: 50, height: 50))
       // btn.setTitle("Filter", for: .normal)
        let btnColour = UIColor(displayP3Red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
        btn.setTitleColor(btnColour, for: .normal)
        btn.titleLabel?.font = headerFont
        btn.setImage(#imageLiteral(resourceName: "search-7"), for: .normal)
        btn.addTarget(self, action: #selector(filterBtnPressed), for: .touchUpInside)
        
        let menuBtn = UIButton(frame: CGRect(x: 20, y: -5, width: 50, height: 50))
      //  menuBtn.setTitle("Menu", for: .normal)
       
        menuBtn.setTitleColor(btnColour, for: .normal)
        menuBtn.titleLabel?.font = headerFont
        menuBtn.addTarget(self, action: #selector(menuBtnPressed), for: .touchUpInside)
        menuBtn.setImage(#imageLiteral(resourceName: "list-fat-7"), for: .normal)
        menuBtn.imageView?.clipsToBounds = true
        
        
        
        let locationBtn = UIButton(frame: CGRect(x: 150, y: -5, width: 50, height: 50))
       // locationBtn.setTitle("Location", for: .normal)
        
        locationBtn.setTitleColor(btnColour, for: .normal)
        locationBtn.titleLabel?.font = headerFont
        locationBtn.addTarget(self, action: #selector(locationBtnPressed), for: .touchUpInside)
        locationBtn.setImage(#imageLiteral(resourceName: "paper-plane-7"), for: .normal)
        
        
        extensionView.addSubview(btn)
        extensionView.addSubview(menuBtn)
        extensionView.addSubview(locationBtn)
        hidingBarMangar = HidingNavigationBarManager(viewController: self, scrollView: tableView)
        hidingBarMangar?.addExtensionView(extensionView)
        
    }
    
    // Used to determine if NSDUserDefaults is empty
    func userDefaultExist(key: String) -> Bool {
        return defaultLocation.object(forKey: key) != nil
    }
    
    @objc func filterBtnPressed() {
        performSegue(withIdentifier: "toApplyFiltersVC", sender: nil)
    }
    @objc func menuBtnPressed() {
        performSegue(withIdentifier: "toSideMenu", sender: nil)
    }
    
    @objc func locationBtnPressed() {
         performSegue(withIdentifier: "toLocationSelectVC", sender: nil)
    }
    
    //Activity display/Loading bar
        func activityIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))

        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        indicator.center = self.view.center
        self.view.addSubview(indicator)
    }
    
}
