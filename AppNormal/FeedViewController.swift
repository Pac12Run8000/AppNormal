//
//  FeedViewController.swift
//  AppNormal
//
//  Created by Michelle Grover on 10/4/16.
//  Copyright © 2016 Norbert Grover. All rights reserved.
//

import UIKit
import Firebase

class FeedViewController: UITableViewController {
    
    let cellId = "cellId"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItemsAndBarButtons()
        checkIfUserLoggedInAndSetUpNavbarTitle()
        
        tableView.separatorColor = ChatMessageCell.orangeishColor
        tableView.backgroundColor = ChatMessageCell.lightBrownishColor
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
        cell.textLabel?.text = "placeholder"
        return cell
    }
    
    func setupNavigationItemsAndBarButtons() {
        navigationController?.navigationBar.barTintColor = ChatMessageCell.orangeishColor
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Compose, target: self, action: #selector(handleAddPostToFeed))
        navigationItem.leftBarButtonItem?.tintColor = ChatMessageCell.blackishColor
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Trash, target: self, action: #selector(handleDeleteFromFeed))
        navigationItem.rightBarButtonItem?.tintColor = ChatMessageCell.blackishColor
        
        if let font = UIFont(name: "Avenir-Heavy", size: 18) {
            navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: font]
        }
    }
    
    func checkIfUserLoggedInAndSetUpNavbarTitle() {
        if (FIRAuth.auth()?.currentUser?.uid == nil) {
            performSelector(#selector(handleLogOut), withObject: nil, afterDelay: 0)
        
        } else {
            let uid = FIRAuth.auth()?.currentUser?.uid
            FIRDatabase.database().reference().child("users").child(uid!).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                if let dictionary = snapshot.value as? [String:AnyObject] {
                    
                    if let FeedName = dictionary["name"] as? String {
                        self.navigationItem.title = "\(FeedName) - Feed"
                    }
                }
                
                }, withCancelBlock: nil)
        }
    }
    
    func handleLogOut() {
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logOutError {
            print(logOutError)
        }
        
        let loginController = LoginController()
        presentViewController(loginController, animated: true, completion: nil)
    }
    
    func handleDeleteFromFeed() {
        let deletePostController = DeletePostController()
        let navController = UINavigationController(rootViewController: deletePostController)
        presentViewController(navController, animated: true, completion: nil)
    }

    func handleAddPostToFeed() {
        let newPostController = NewPostController()
        let navController = UINavigationController(rootViewController: newPostController)
        presentViewController(navController, animated: true, completion: nil)
    }

    

   

}
