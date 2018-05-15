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
import ImageSlideshow
import SwiftKeychainWrapper
import CFAlertViewController
import Contacts



class DetailVC: UIViewController {
  
    var userID = ""
    var rentalTitle = ""
    var rentalType = ""
    var bond = ""
    var rent = ""
    var rentalPeriod = ""
    var pets = ""
    var des = ""
    var imageOneUrl: String?
    var imageTwoUrl: String?
    var imageThreeUrl: String?
    var imageFourUrl : String?
    var lat: Double?
    var long: Double? 
    var postID = ""
    var imageArray = [UIImage]()

    
    var imageOne: UIImage?
    var imageTwo: UIImage?
    var imageThree: UIImage?
    var imageFour: UIImage?

    var localImageSource = [ImageSource]()
    
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
        if bond == "" {
            bondField.text = "No Bond"
        } else {
            bondField.text = bond
            
        }
        
        rentField.text = "$\(rent)"
        dateAvalField.text = rentalPeriod
        petsField.text = pets
        descriptionField.text = des
        
        
        loadImagesIntoImageSlider()
        addMapAnnotation()
        


        
      
        

        
        
        
        
        
    }
    
    
    func loadImagesIntoImageSlider() {
        
        
        if let imageOneUrl = self.imageOneUrl {
            if RentalTableViewVC.imageCache.object(forKey: imageOneUrl as NSString) == nil {
                let ref = Storage.storage().reference(forURL: imageOneUrl)
                ref.getData(maxSize: 2 * 1024 * 1024, completion: { (data, error) in
                    if error != nil {
                        // Error
                    } else {
                        if let imageData = data {
                            let imageOne = UIImage(data: imageData)
                            self.imageSlider.setImageInputs(self.appendImageToSlider(img1: imageOne, img2: nil , img3: nil, img4: nil))
                            
                            
                            if let imageTwoUrl = self.imageTwoUrl {
                                let ref = Storage.storage().reference(forURL: imageTwoUrl)
                                ref.getData(maxSize: 2 * 1024 * 1024, completion: { (data, error) in
                                    if error != nil {
                                        // Error
                                    } else {
                                        if let imageData = data {
                                            let imageTwo = UIImage(data: imageData)
                                            self.imageSlider.setImageInputs(self.appendImageToSlider(img1: imageOne, img2: imageTwo , img3: nil, img4: nil))
                                            if let imageTwo = imageTwo {
                                                RentalTableViewVC.imageCache.setObject(imageTwo, forKey: imageTwoUrl as NSString)
                                            }
                                            
                                            if let imageThreeUrl = self.imageThreeUrl {
                                                let ref = Storage.storage().reference(forURL: imageThreeUrl)
                                                ref.getData(maxSize: 2 * 1024 * 1024, completion: { (data, error) in
                                                    if error != nil {
                                                        // Error
                                                    } else {
                                                        if let imageData = data {
                                                            let imageThree = UIImage(data: imageData)
                                                            self.imageSlider.setImageInputs(self.appendImageToSlider(img1: imageOne, img2: imageTwo , img3: imageThree, img4: nil))
                                                            if let imageThree = imageThree {
                                                                RentalTableViewVC.imageCache.setObject(imageThree, forKey: imageThreeUrl as NSString)
                                                            }
                                                            
                                                            
                                                            
                                                            if let imageFourUrl = self.imageFourUrl {
                                                                let ref = Storage.storage().reference(forURL: imageFourUrl)
                                                                ref.getData(maxSize: 2 * 1024 * 1024, completion: { (data, error) in
                                                                    if error != nil {
                                                                        // Error
                                                                    } else {
                                                                        if let imageData = data {
                                                                            let imageFour = UIImage(data: imageData)
                                                                            self.imageSlider.setImageInputs(self.appendImageToSlider(img1: imageOne, img2: imageTwo , img3: imageThree, img4: imageFour))
                                                                            
                                                                            if let imageFour = imageFour {
                                                                                RentalTableViewVC.imageCache.setObject(imageFour, forKey: imageFourUrl as NSString)
                                                                            }
                                                                            
                                                                            
                                                                        }
                                                                    }
                                                                })
                                                            }
                                                            
                                                            
                                                        }
                                                    }
                                                })
                                            }
                                            
                                            
                                            
                                        }
                                    }
                                })
                            }
                            
                        }
                    }
                })
            } else {
                if let imageOne = RentalTableViewVC.imageCache.object(forKey: imageOneUrl as NSString) {
                    self.imageSlider.setImageInputs(self.appendImageToSlider(img1: imageOne, img2: nil , img3: nil, img4: nil))
                    
                    if let imageTwoUrl = self.imageTwoUrl {
                        if let imageTwo = RentalTableViewVC.imageCache.object(forKey: imageTwoUrl as NSString) {
                            self.imageSlider.setImageInputs(self.appendImageToSlider(img1: imageOne, img2: imageTwo , img3: nil, img4: nil))
                            
                            if let imageThreeUrl = self.imageThreeUrl {
                                if let imageThree = RentalTableViewVC.imageCache.object(forKey: imageThreeUrl as NSString) {
                                    self.imageSlider.setImageInputs(self.appendImageToSlider(img1: imageOne, img2: imageTwo , img3: imageThree, img4: nil))
                                    
                                    if let imageFourUrl = self.imageFourUrl {
                                        if let imageFour = RentalTableViewVC.imageCache.object(forKey: imageFourUrl as NSString) {
                                            self.imageSlider.setImageInputs(self.appendImageToSlider(img1: imageOne, img2: imageTwo , img3: imageThree, img4: imageFour))
                                        }
                                    }
                                }
                            }
                        } else {
                            
                            let ref = Storage.storage().reference(forURL: imageTwoUrl)
                            ref.getData(maxSize: 2 * 1024 * 1024, completion: { (data, error) in
                                if error != nil {
                                    //Error
                                } else {
                                    if let imageData = data {
                                        if let imageTwo = UIImage(data: imageData) {
                                            self.imageSlider.setImageInputs(self.appendImageToSlider(img1: imageOne, img2: imageTwo , img3: nil, img4: nil))
                                            RentalTableViewVC.imageCache.setObject(imageTwo, forKey: imageTwoUrl as NSString)
                                            
                                            
                                            if let imageThreeUrl = self.imageThreeUrl {
                                                if let imageThree = RentalTableViewVC.imageCache.object(forKey: imageThreeUrl as NSString) {
                                                    self.imageSlider.setImageInputs(self.appendImageToSlider(img1: imageOne, img2: imageTwo , img3: imageThree, img4: nil))
                                                } else {
                                                    let ref = Storage.storage().reference(forURL: imageThreeUrl)
                                                    ref.getData(maxSize: 2 * 1024 * 1024, completion: { (data, error) in
                                                        if error != nil {
                                                            //error
                                                        } else {
                                                            if let imageData = data {
                                                                if let imageThree = UIImage(data: imageData) {
                                                                    self.imageSlider.setImageInputs(self.appendImageToSlider(img1: imageOne, img2: imageTwo , img3: imageThree, img4: nil))
                                                                    RentalTableViewVC.imageCache.setObject(imageThree, forKey: imageThreeUrl as NSString)
                                                                    
                                                                    if let imageFourUrl = self.imageFourUrl {
                                                                        if let imageFour = RentalTableViewVC.imageCache.object(forKey: imageFourUrl as NSString) {
                                                                            //If in Cache
                                                                            self.imageSlider.setImageInputs(self.appendImageToSlider(img1: imageOne, img2: imageTwo , img3: imageThree, img4: imageFour))
                                                                        } else {
                                                                            //Download
                                                                            let ref = Storage.storage().reference(forURL: imageFourUrl)
                                                                            ref.getData(maxSize: 2 * 1024 * 1024, completion: { (data, error) in
                                                                                if error != nil {
                                                                                    //Error
                                                                                } else {
                                                                                    if let imageData = data, let imageFour = UIImage(data: imageData) {
                                                                                        self.imageSlider.setImageInputs(self.appendImageToSlider(img1: imageOne, img2: imageTwo , img3: imageThree, img4: imageFour))
                                                                                        RentalTableViewVC.imageCache.setObject(imageFour, forKey: imageFourUrl as NSString)
                                                                                    }
                                                                                }
                                                                            })
                                                                        }
                                                                    }
                                                                    
                                                                }
                                                            }
                                                        }
                                                    })
                                                }
                                            }
                                            
                                            
                                            
                                        }
                                        
                                    }
                                }
                            })
                            
                            
                        }
                        
                        
                        
                    }
                    
                }
            }
            
            
            
            
            
            
        }
        
        
        
        
        
    }
    
    
    
    
    
    func appendImageToSlider(img1: UIImage?, img2: UIImage?, img3: UIImage?, img4: UIImage?) -> [ImageSource] {
        
        var localImageSrc = [ImageSource]()
        
        
        if let img1 = img1 {
            localImageSrc = [ImageSource(image: img1)]
            if let img2 = img2 {
                  localImageSrc = [ImageSource(image: img1), ImageSource(image: img2)]
                if let img3 = img3 {
                      localImageSrc = [ImageSource(image: img1), ImageSource(image: img2),ImageSource(image: img3)]
                    if let img4 = img4 {
                          localImageSrc = [ImageSource(image: img1), ImageSource(image: img2),ImageSource(image: img3),ImageSource(image: img4)]
                    }
                }
            }
        }
    
        return localImageSrc
    }

    
    
    
 //   if RentalTableViewVC.imageCache.object(forKey: imageOneUrl! as NSString) == nil {
    //                let refImageOne = Storage.storage().reference(forURL: imageOneUrl!)
    //                refImageOne.getData(maxSize:  2 * 1024 * 1024, completion: { (data, error) in
    //                    if error != nil {
    //                        print("An error has occured downloading image")
    //                    } else {
    //                        print("Image downloaded")
    //                        if let imageData = data {
    //                            if let imgOne = UIImage(data: imageData) {
    //                                //  self.imageArray.append(img)
    //                                RentalTableViewVC.imageCache.setObject(imgOne, forKey: self.imageOneUrl! as NSString)
    //                                self.localImageSource = [ImageSource(image: imgOne)]
    //                                self.imageSlider.setImageInputs(self.localImageSource)
//
//    func downloadImageFromUrl(url : String) -> UIImage? {
//        var imageToReturn: UIImage?
//        let ref = Storage.storage().reference(forURL: url)
//        ref.getData(maxSize: 2 * 1024 * 1024) { (data, error) in
//            if error != nil {
//                print("Error occured downloading image")
//            } else {
//                if let imageData = data {
//                    if let image = UIImage(data: imageData) {
//                        imageToReturn = image
//                    }
//                }
//            }
//        }
//        return imageToReturn
//    }
    
    
    

    
    
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
        let annotation = MKPointAnnotation()
        
        if let lat = self.lat, let long = self.long {
            let location = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let viewRegion = MKCoordinateRegionMakeWithDistance(location, 1500, 1500)
            annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            map.setRegion(viewRegion, animated: false)
            map.addAnnotation(annotation)
            
        }
       
    }
    
    func mapView(_ mapView: MKMapView, annotationView view:MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let placemark = MKPlacemark(coordinate: view.annotation!.coordinate, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        let launchOptions = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeTransit]
        self.title = title
        mapItem.name = title
        mapItem.openInMaps(launchOptions: launchOptions)
    }
    
    
    @IBAction func addToFavouratesBtnPressed(_ sender: Any) {
        let postDataToUsers = DataService.ds.DBCurrentUser.child("MyFavourates").child(postID)
        postDataToUsers.setValue(true)
        
        
        // Create Alet View Controller
        let alertController = CFAlertViewController(title: "Favourate added! ",
                                                    message: "This property has been added to your favourate list",
                                                    textAlignment: .left,
                                                    preferredStyle: .alert,
                                                    didDismissAlertHandler: nil)
        // Create Upgrade Action
        let defaultAction = CFAlertAction(title: "Ok",
                                          style: .Default,
                                          alignment: .center,
                                          backgroundColor: UIColor(red: CGFloat(46.0 / 255.0), green: CGFloat(204.0 / 255.0), blue: CGFloat(113.0 / 255.0), alpha: CGFloat(1)),
                                          textColor: nil,
                                          handler: { (action) in
                                            // Handle btn press
        })
        
        
        let goToFavourates = CFAlertAction(title: "View My Favourates",
                                          style: .Default,
                                          alignment: .center,
                                          backgroundColor: UIColor(red: CGFloat(46.0 / 255.0), green: CGFloat(204.0 / 255.0), blue: CGFloat(113.0 / 255.0), alpha: CGFloat(1)),
                                          textColor: nil,
                                          handler: { (action) in
                                            
                                            print("Button with title '" + action.title! + "' tapped")
                                            self.performSegue(withIdentifier: "toMyFavouratesVC", sender: nil)
        })
        
        
        // Add Action Button Into Alert
        alertController.addAction(defaultAction)
         alertController.addAction(goToFavourates)
        // Present Alert View Controller
        present(alertController, animated: true, completion: nil)
        
        
       
    }
    
}
