//
//  EmailVC.swift
//  Login
//
//  Created by George on 14/12/2017.
//  Copyright © 2017 George Woolley. All rights reserved.
//

import Foundation
import MessageUI
import Firebase
import SimpleImageViewer
import MapKit
import Whisper
import ImageSlideshow
import SwiftKeychainWrapper



class DetailVC: UIViewController {
  
    var userID = ""
    var rentalTitle = ""
    var rentalType = ""
    var bond = ""
    var rent = ""
    var rentalPeriod = ""
    var pets = ""
    var des = ""
    var imageURL = ""
    var lat: Double?
    var long: Double? 
    var postID = ""
    
//    var address: String {
//        return "\(streetName), \(city), \(postcode)"
//    }
    
    @IBOutlet weak var map: MKMapView!
    

    @IBOutlet weak var imageSlider: ImageSlideshow!
    
    @IBOutlet weak var titleField: UILabel!

    @IBOutlet weak var houseTypeField: UILabel!
    @IBOutlet weak var bondField: UILabel!
    @IBOutlet weak var rentField: UILabel!
    @IBOutlet weak var dateAvalField: UILabel!
    @IBOutlet weak var petsField: UILabel!
    @IBOutlet weak var descriptionField: UILabel!
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpSlider()
        
   
        
        titleField.text = rentalTitle
        houseTypeField.text = rentalType
        bondField.text = bond
        rentField.text = rent
        dateAvalField.text = rentalPeriod
        petsField.text = pets
        descriptionField.text = des
        
        addMapAnnotation()
     
        if let img = RentalTableViewVC.imageCache.object(forKey: imageURL as NSString) {
            let localSource = [ImageSource(imageString: "house")!,ImageSource(image: img)]
             imageSlider.setImageInputs(localSource)
            
        } else {
            // download image from Firebase
            let ref = Storage.storage().reference(forURL: imageURL)
            ref.getData(maxSize:  2 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print("An error has occured downloading image")
                } else {
                    print("Image downloaded")
                    if let imageData = data {
                        if let img = UIImage(data: imageData) {
                            let localSource = [ImageSource(imageString: "house")!,ImageSource(image: img)]
                            self.imageSlider.setImageInputs(localSource)
                            RentalTableViewVC.imageCache.setObject(img, forKey: self.imageURL as NSString)
                        }
                    }
                }
            })
        }
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toChatVC" {
            if let destination = segue.destination as? ChatVC {
                destination.recieveMessageUserID = userID 
            }
        }
    }
   
    func setUpSlider() {
        imageSlider.backgroundColor = UIColor.white
        imageSlider.slideshowInterval = 5.0
        imageSlider.pageControlPosition = PageControlPosition.underScrollView
        imageSlider.pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        imageSlider.pageControl.pageIndicatorTintColor = UIColor.black
        imageSlider.contentScaleMode = UIViewContentMode.scaleAspectFill
        
        // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
        imageSlider.activityIndicator = DefaultActivityIndicator()
       
        //Setup tap gesture on image to go full screen
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(DetailVC.didTap))
        imageSlider.addGestureRecognizer(recognizer)
        
    }
    
    @objc func didTap() {
        let fullScreenController = imageSlider.presentFullScreenController(from: self)
        // set the activity indicator for full screen controller (skipping the line will show no activity indicator)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }
    
    @IBAction func contactBtnPressed(_ sender: Any) {
        
    performSegue(withIdentifier: "toChatVC", sender: nil)
        
    }
    

    

    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    


    func addMapAnnotation() {
//        let geocoder = CLGeocoder()
//
//        geocoder.geocodeAddressString(address) { (placemarks, error) in
//
//            if error != nil {
//                //Deal with error here
//            } else if let placemarks = placemarks {
//
//                if let coordinate = placemarks.first?.location?.coordinate {
//                    let pin = PinAnnotation(title: "WannaRental Property", subtitle: "wanaka", coordinate: coordinate)
//                    self.map.setRegion(MKCoordinateRegionMakeWithDistance(coordinate, 1500, 1500), animated: true)
//                    self.map.addAnnotation(pin)
//                }
//            }
//        }
    }
    

    @IBAction func addToFavouratesBtnPressed(_ sender: Any) {
        let postDataToUsers = DataService.ds.DBCurrentUser.child("MyFavourates").child(postID)
        postDataToUsers.setValue(true)
        

        
        var announcement = Announcement(title: "", subtitle: "This property has been added to your favourate page", image: UIImage(named: "if_tick_blue_619551"))
        announcement.duration = 2
        
        Whisper.show(shout: announcement, to: navigationController!, completion: {
           
        })
    }
    
}
