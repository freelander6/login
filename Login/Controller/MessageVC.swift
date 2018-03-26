//
//  ChatVC.swift
//  Login
//
//  Created by George on 07/02/2018.
//  Copyright © 2018 George Woolley. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import SwiftKeychainWrapper


class MessageVC: JSQMessagesViewController {
    
    var recieveUserID = ""
    var threadID = ""
    var myThreadID: String?
    
    //Local messgae array
    var messages = [JSQMessage]()
    
    // Image bubble properties
    lazy var outgoingMessageBubble : JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory()!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }()
    
    lazy var incomingMessageBubble: JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory()!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let senderUID = KeychainWrapper.standard.string(forKey: "uid")
        
        senderId = senderUID
        senderDisplayName = ""
        
        let threadQuery = DataService.ds.DBCurrentUser.child("MyThreads")
        _ = threadQuery.observe(.childAdded, with: { snapshot in
            
            print(snapshot.key)
            self.threadID = snapshot.key
            
            
            if self.threadID != "" {
                
                let query = DataService.ds.DBrefThreads.child(self.threadID).child("Messages").queryLimited(toLast: 10)     // Gets the last 10 messages
                
                _ = query.observe(.childAdded, with: { [weak self] snapshot in
                    
                    if  let data        = snapshot.value as? [String: String],
                        let id          = data["senderID"],
                        let name        = data["name"],
                        let text        = data["text"],
                        !text.isEmpty
                    {
                        if let message = JSQMessage(senderId: id, displayName: name, text: text)
                        {
                            self?.messages.append(message)
                            
                            self?.finishReceivingMessage()   // Refresh UI
                        }
                    }
                })
                
                
            }
            
            
        })
        
        
//        let myThreads = DataService.ds.DBCurrentUser.child("MyThreads")
//
//        _ = myThreads.observe(.childAdded, with: { (snapshot) in
//
//                self.myThreadID = snapshot.key
//           // print("My thread ID is : \(String(describing: self.myThreadID))")
//
//        })
        
        inputToolbar.contentView.leftBarButtonItem = nil    // Hides attactment button
        collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize.zero  // avatar size zero
        collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero  // avatar size zero
        
        //Obseriving firbase
      //  if let myThreadID = myThreadID 
            
        if threadID != "" {
        
    
            
    }
        
 
        
}
    
    //Displaying a users name
//    @objc func showDisplayNameDialog()
//    {
//        let defaults = UserDefaults.standard
//
//        let alert = UIAlertController(title: "Your Display Name", message: "Before you can chat, please choose a display name. Others will see this name when you send chat messages. You can change your display name again by tapping the navigation bar.", preferredStyle: .alert)
//
//        alert.addTextField { textField in
//
//            if let name = defaults.string(forKey: "jsq_name")
//            {
//                textField.text = name
//            }
//            else
//            {
//                let names = ["Ford", "Arthur", "Zaphod", "Trillian", "Slartibartfast", "Humma Kavula", "Deep Thought"]
//                textField.text = names[Int(arc4random_uniform(UInt32(names.count)))]
//            }
//        }
//
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self, weak alert] _ in
//
//            if let textField = alert?.textFields?[0], !textField.text!.isEmpty {
//
//                self?.senderDisplayName = textField.text
//
//                self?.title = "Chat: \(self!.senderDisplayName!)"
//
//                defaults.set(textField.text, forKey: "jsq_name")
//                defaults.synchronize()
//            }
//        }))
//
//        present(alert, animated: true, completion: nil)
//    }
    
    
    
    // JSQMessage required fuctions
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    //Mesage bubbles
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        return messages[indexPath.item].senderId == senderId ? outgoingMessageBubble : incomingMessageBubble
    }
    //Avatar setup
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    // Set the name label text
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString!
    {
        return messages[indexPath.item].senderId == senderId ? nil : NSAttributedString(string: messages[indexPath.item].senderDisplayName)
    }
    // Set the height of top label
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat
    {
        return messages[indexPath.item].senderId == senderId ? 0 : 15
    }
    // When set is pressed
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        let threadFireRef = DataService.ds.DBrefThreads.child(threadID).child("Messages").childByAutoId()
        let currentUserThreadRef = DataService.ds.DBCurrentUser
        let recieveUserRef = DataService.ds.DBrefUsers
        let message = ["senderID": senderId, "name": senderDisplayName, "text": text]
        threadFireRef.setValue(message)
        currentUserThreadRef.child("MyThreads").child(threadID).setValue(senderId)
      //  recieveUserRef.child(senderUserID).child("MyThreads").child(threadID).setValue(senderId)
        finishSendingMessage()
    }
}

