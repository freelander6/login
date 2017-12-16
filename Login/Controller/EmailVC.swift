//
//  EmailVC.swift
//  Login
//
//  Created by George on 14/12/2017.
//  Copyright © 2017 George Woolley. All rights reserved.
//

import UIKit
import MessageUI

class EmailVC: UIViewController, MFMailComposeViewControllerDelegate {
  
    var emailAdress = "" 
    @IBOutlet weak var emailLbl: UILabel!
    
  
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailLbl.text = emailAdress
        print(emailAdress)
    }

//    func sendEmail() {
//
//    }
//
//    func setupMailController() -> MFMailComposeViewController {
//        let mailComposerVC = MFMailComposeViewController()
//        mailComposerVC.mailComposeDelegate = self
//
//        mailComposerVC.setToRecipients(["test@msn.com"])
//        mailComposerVC.setSubject("Test subject")
//        mailComposerVC.setMessageBody("Test body", isHTML: false)
//
//        return mailComposerVC
//    }
//
//    func showMailError(){
//        let emailErrorAlert = UIAlertController(title: "Error sending email", message: "Your device could not send the email", preferredStyle: .alert)
//        let dismiss = UIAlertAction(title: "Ok", style: .default, handler: nil)
//
//
//    }
//

}
