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
        
//        let ref = FIRDatabase.database().referenceFromURL("https://appnormal-e8c55.firebaseio.com/")
//        ref.updateChildValues(["someValue": 123123])
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: #selector(handleLogout))
        navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 1.00, green: 0.53, blue: 0.14, alpha: 1.0)
        if let font = UIFont(name: "Avenir-Book", size: 18) {
            navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSFontAttributeName: font], forState: .Normal)
        }
        
        
        
    }
    
    
    
    func handleLogout() {
        let loginController = LoginController()
        
        presentViewController(loginController, animated: true, completion: nil)
    }
    
    
}

