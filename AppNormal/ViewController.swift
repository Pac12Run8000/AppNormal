//
//  ViewController.swift
//  AppNormal
//
//  Created by Michelle Grover on 10/4/16.
//  Copyright © 2016 Norbert Grover. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor(red: 1.00, green: 0.53, blue: 0.14, alpha: 1.0)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: #selector(handleLogout))
        navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 0.05, green: 0.00, blue: 0.00, alpha: 1.0)
        if let font = UIFont(name: "Avenir-Book", size: 18) {
            navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSFontAttributeName: font], forState: .Normal)
        }
        
        if (FIRAuth.auth()?.currentUser?.uid == nil) {
            performSelector(#selector(handleLogout), withObject: nil, afterDelay: 0)
            
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

