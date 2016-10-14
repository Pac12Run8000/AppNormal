//
//  FeedViewController.swift
//  AppNormal
//
//  Created by Michelle Grover on 10/4/16.
//  Copyright © 2016 Norbert Grover. All rights reserved.
//

import UIKit

class FeedViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = ChatMessageCell.orangeishColor
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Compose, target: self, action: #selector(handleAddPostToFeed))
        navigationItem.leftBarButtonItem?.tintColor = ChatMessageCell.blackishColor
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Trash, target: self, action: #selector(handleDeleteFromFeed))
        navigationItem.rightBarButtonItem?.tintColor = ChatMessageCell.blackishColor
        navigationItem.title = "Feed"
        
        if let font = UIFont(name: "Avenir-Heavy", size: 18) {
            navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: font]
        }
     
        tableView.separatorColor = ChatMessageCell.orangeishColor
        tableView.backgroundColor = ChatMessageCell.lightBrownishColor

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
