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
        
        init(thread: String, user: String) {
            self.threadID = thread
            self.username = user
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
            
            
         
                let users = DataService.ds.DBrefUsers.child(senderID!).child("MyDetails")
            
                users.observe(.value, with: { (snapshot) in
                    if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                        for snap in snapshots {
                         //  print(snap)
                            if snap.key == "username" {
                                if let username = snap.value as? String {
                                    let thread = Thread(thread: threadKey, user: username)
                                    self.myThreads.append(thread)
                                    self.chatListTableView.reloadData()
                                }
                               
                                
                            }
                            
                        }
                    
                }
                    
                })
            
            
            self.chatListTableView.reloadData()
            
            
            }
        
        
        
            
            
          self.chatListTableView.reloadData()
            
        }
    
    

    
    
     
        
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = chatListTableView.dequeueReusableCell(withIdentifier: "cell") as? ChatListCell {
            
           let thread = myThreads[indexPath.row].username
            
           cell.configureCell(houseTitle: thread)
            
            
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
        performSegue(withIdentifier: "toMessageVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMessageVC" {
            if let destination = segue.destination as? MessageVC {
                if let value = chatListTableView.indexPathForSelectedRow?.row {
                    destination.threadID = myThreads[value].threadID
                }
                
            }
        }
    }
    


}
