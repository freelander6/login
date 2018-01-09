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



class DetailVC: UIViewController, MFMailComposeViewControllerDelegate {
  
    var emailAdress = ""
    var rentalTitle = ""
    var rentalType = ""
    var bond = ""
    var rent = ""
    var dateAval = ""
    var pets = ""
    var des = ""
    var imageURL = ""
    var streetName = ""
    var city = ""
    var postcode = ""
    
    var address: String {
        return "\(streetName), \(city), \(postcode)"
    }
    
    @IBOutlet weak var map: MKMapView!
    

    @IBOutlet weak var titleField: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var houseTypeField: UILabel!
    @IBOutlet weak var bondField: UILabel!
    @IBOutlet weak var rentField: UILabel!
    @IBOutlet weak var dateAvalField: UILabel!
    @IBOutlet weak var petsField: UILabel!
    @IBOutlet weak var descriptionField: UILabel!
    
    
    
    
//    final class rentalAnnotation: NSObject, MKAnnotation {
//        var coordinate: CLLocationCoordinate2D
//        var title: String?
//        var subtitle: String?
//
//        init(coord: CLLocationCoordinate2D, title: String, subtitle: String) {
//            self.coordinate = coord
//            self.title = title
//            self.subtitle = subtitle
//
//            super.init()
//        }
//
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        titleField.text = rentalTitle
        houseTypeField.text = rentalType
        bondField.text = bond
        rentField.text = rent
        dateAvalField.text = dateAval
        petsField.text = pets
        descriptionField.text = des
        
        addMapAnnotation()
     
        if let img = RentalTableViewVC.imageCache.object(forKey: imageURL as NSString) {
            image.image = img
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
                            self.image.image = img
                            RentalTableViewVC.imageCache.setObject(img, forKey: self.imageURL as NSString)
                        }
                    }
                }
            })
        }
        
    }

    
   
    
    
    
    @IBAction func contactBtnPressed(_ sender: Any) {
        
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
        
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients([emailAdress])
        mailComposerVC.setSubject("RE WannaRental enquiry ")
       // mailComposerVC.setMessageBody("Set message body here", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func imageGestureTapped(_ sender: Any) {
        print("pressed")
        let configuration = ImageViewerConfiguration { config in
            config.imageView = image
        }
        
        let imageViewerController = ImageViewerController(configuration: configuration)
        
        present(imageViewerController, animated: true)
    }
    

    func addMapAnnotation() {
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            
            if error != nil {
                //Deal with error here
            } else if let placemarks = placemarks {
                
                if let coordinate = placemarks.first?.location?.coordinate {
                    let pin = PinAnnotation(title: "WannaRental Property", subtitle: "wanaka", coordinate: coordinate)
                    self.map.setRegion(MKCoordinateRegionMakeWithDistance(coordinate, 1500, 1500), animated: true)
                    self.map.addAnnotation(pin)
                }
            }
        }
    }
    


}
