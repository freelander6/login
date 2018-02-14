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
    
    var myThreads: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        chatListTableView.delegate = self
        chatListTableView.dataSource = self
        
        let threads = DataService.ds.DBCurrentUser.child("MyThreads")
        
        threads.observe(.childAdded) { (snapshot) in
            
                print(snapshot.key)
                self.myThreads.append(snapshot.key)
                print(self.myThreads)
            
                self.chatListTableView.reloadData()
            
            }
        
            
            
          self.chatListTableView.reloadData()
            
        }
        
     
        
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = chatListTableView.dequeueReusableCell(withIdentifier: "cell") as? ChatListCell {
            
           let thread = myThreads[indexPath.row]
            
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
                    destination.threadID = myThreads[value]
                }
                
            }
        }
    }
    


}
