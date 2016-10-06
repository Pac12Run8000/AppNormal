//
//  ViewController.swift
//  AppNormal
//
//  Created by Michelle Grover on 10/4/16.
//  Copyright © 2016 Norbert Grover. All rights reserved.
//

import UIKit
import Firebase

class MessagesController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor(red: 1.00, green: 0.53, blue: 0.14, alpha: 1.0)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: #selector(handleLogout))
        navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 0.05, green: 0.00, blue: 0.00, alpha: 1.0)
        if let font = UIFont(name: "Avenir-Book", size: 18) {
            navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSFontAttributeName: font], forState: .Normal)
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Compose, target: self, action: #selector(handleNewMessage))
        navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 0.05, green: 0.00, blue: 0.00, alpha: 1.0)
        checkIfUserIsLoggedIn()
    }
    
    func handleNewMessage() {
        let newMessageController = NewMessageController()
        let navController = UINavigationController(rootViewController: newMessageController)
        presentViewController(navController, animated: true, completion: nil)
    }
    
    func checkIfUserIsLoggedIn() {
        if (FIRAuth.auth()?.currentUser?.uid == nil) {
            performSelector(#selector(handleLogout), withObject: nil, afterDelay: 0)
        } else {
            guard let uid = FIRAuth.auth()?.currentUser?.uid else {
                return
            }
            FIRDatabase.database().reference().child("users").child(uid).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                if let dictionary = snapshot.value as? [String:AnyObject] {
                    self.navigationItem.title = dictionary["name"] as? String
                }
                
                }, withCancelBlock: nil)
            
        }
    }
    
    func handleLogout() {
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutErr {
            print(logoutErr)
        }
        
        
        
        let loginController = LoginController()
        
        presentViewController(loginController, animated: true, completion: nil)
    }
    
    
}

