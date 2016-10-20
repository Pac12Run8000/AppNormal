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
    
    var posts = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItemsAndBarButtons()
        checkIfUserLoggedInAndSetUpNavbarTitle()
        
        tableView.registerClass(PostCell.self, forCellReuseIdentifier: cellId)
        
        tableView.separatorColor = ChatMessageCell.orangeishColor
        tableView.backgroundColor = ChatMessageCell.lightBrownishColor
        fetchUser()
        
    }
    
    func fetchUser() {
        FIRDatabase.database().reference().child("feed").observeEventType(.ChildAdded, withBlock: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let post = Post()
                post.setValuesForKeysWithDictionary(dictionary)
                self.posts.append(post)
                
                dispatch_async(dispatch_get_main_queue(), { 
                     self.tableView.reloadData()
                })
               
            }
            }, withCancelBlock: nil)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath)
        let post = posts[indexPath.row]
        cell.textLabel?.text = post.comment
        cell.detailTextLabel?.text = post.fromId
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
        self.navigationItem.title = "Feed"
        if (FIRAuth.auth()?.currentUser?.uid == nil) {
            performSelector(#selector(handleLogOut), withObject: nil, afterDelay: 0)
        
        } else {
            let uid = FIRAuth.auth()?.currentUser?.uid
            FIRDatabase.database().reference().child("users").child(uid!).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                 self.navigationItem.title = "Feed"
                if let dictionary = snapshot.value as? [String:AnyObject] {
                    let user = User()
                    user.setValuesForKeysWithDictionary(dictionary)
//                    self.navigationItem.title = user.name

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

class PostCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
