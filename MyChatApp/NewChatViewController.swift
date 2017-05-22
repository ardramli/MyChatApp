//
//  NewChatViewController.swift
//  MyChatApp
//
//  Created by ardMac on 11/04/2017.
//  Copyright © 2017 ardMac. All rights reserved.
//

import UIKit
import Firebase
class NewChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    var users = [User]()
    var messagesController : MessagesViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        //tableView.register(UserCell.self, forCellReuseIdentifier: "userListCell")
        
        fetchUser()

        // Do any additional setup after loading the view.
    }
    
    
    func fetchUser() {
        FIRDatabase.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: Any] {
                let user = User()
                user.id = snapshot.key
                
                // If you use this setter, your app will crash if your class properties don't exactly match up with the firebase dictionary keys
                user.setValuesForKeys(dictionary)
                
                self.users.append(user)
                
                // This will crash because of background thread, so let's use dispatch_async to fix
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            }
        }, withCancel: nil)
    }
    
    func handleCancel() {
       
        navigationController?.popViewController(animated: true)
    }
    
}

extension NewChatViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "userListCell", for: indexPath) as! UserCell
        
        let user = users[indexPath.row]
        cell.nameLabel?.text = user.name
        cell.emailLabel?.text = user.email
        
        if let profileimageUrl = user.profileImageUrl {
            
            cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileimageUrl)
        }
        
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            
            if let goToViewController = self.storyboard?.instantiateViewController(withIdentifier: "ChatLogViewController") as? ChatLogViewController {
                goToViewController.user = self.users[indexPath.row]
                self.navigationController?.pushViewController(goToViewController, animated: true)
                
                
            }
            
        }
}

extension UINavigationController {
    func pop(animated: Bool) {
        _ = self.popViewController(animated: animated)
    }
    
    func popToRoot(animated: Bool) {
        _ = self.popToRootViewController(animated: animated)
    }
}




