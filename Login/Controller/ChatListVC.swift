//
//  ChatsVC.swift
//  Login
//
//  Created by George on 14/02/2018.
//  Copyright © 2018 George Woolley. All rights reserved.
//

import UIKit
import Firebase

class ChatListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var chatListTableView: UITableView!
    
    class Thread {
        
        var threadID : String
        var username: String
        var imageURL: String?
        
        init(thread: String, user: String, img: String?) {
            self.threadID = thread
            self.username = user
            self.imageURL = img
        }
        
    }
    
    var myThreads = [Thread]()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        chatListTableView.delegate = self
        chatListTableView.dataSource = self
        
        let threads = DataService.ds.DBCurrentUser.child("MyThreads")
        
        threads.observe(.childAdded) { (snapshot) in
            
                print(snapshot.key)
            
                let threadKey = snapshot.key
                let senderID = snapshot.value as? String
                var username = ""
                var imageurl = ""
            
         
                let users = DataService.ds.DBrefUsers.child(senderID!).child("MyDetails")
            
                users.observe(.value, with: { (snapshot) in
                    if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                        for snap in snapshots {
                         //  print(snap)
                            if snap.key == "username" {
                                username = snap.value as! String
                            }
                            if snap.key == "profileImageURL" {
                                imageurl = snap.value as! String
                            }
                        }
                        let thread = Thread(thread: threadKey, user: username, img: imageurl)
                        self.myThreads.append(thread)
                        self.chatListTableView.reloadData()
                    }
                    
                })
             }
        }
    
    

    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = chatListTableView.dequeueReusableCell(withIdentifier: "cell") as? ChatListCell {
            
           let thread = myThreads[indexPath.row].username
            let img = myThreads[indexPath.row].imageURL
            
           cell.configureCell(houseTitle: thread, imgUrl: img)
            
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myThreads.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toChatVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toChatVC" {
            if let destination = segue.destination as? ChatVC {
                if let value = chatListTableView.indexPathForSelectedRow?.row {
                    destination.thread = myThreads[value].threadID
                }
                
            }
        }
    }
    


}
