//
//  ChatListCell.swift
//  Login
//
//  Created by George on 14/02/2018.
//  Copyright © 2018 George Woolley. All rights reserved.
//

import UIKit
import Firebase

class ChatListCell: UITableViewCell {

    @IBOutlet weak var cellLabel: UILabel!

    @IBOutlet weak var userProfileImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(houseTitle: String, imgUrl: String?) {
        cellLabel.text = houseTitle
        if let imgUrl = imgUrl {
            let ref = Storage.storage().reference(forURL: imgUrl)
            ref.getData(maxSize:  2 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print("An error has occured downloading image")
                } else {
                    print("Image downloaded")
                    if let imageData = data {
                        if let img = UIImage(data: imageData) {
                            self.userProfileImage.image = img
                            
                        }
                    }
                }
            })
        }
        
    }
      

}
