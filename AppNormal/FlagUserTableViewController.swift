//
//  DeleteUserTableViewController.swift
//  AppNormal
//
//  Created by Michelle Grover on 11/17/16.
//  Copyright © 2016 Norbert Grover. All rights reserved.
//

import UIKit
import Firebase

class FlagUserTableViewController: UITableViewController, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    let cellId = "cellId"

    var users = [User]()
    var filteredUsers = [User]()
    var usersDictionary = [String:User]()
    var searchController: UISearchController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorColor = ChatMessageCell.orangeishColor
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellId)
        fetchUser()
        
        
        
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        self.searchController.searchResultsUpdater = self
        self.searchController.searchBar.sizeToFit()
        self.searchController.dimsBackgroundDuringPresentation = false
        
        self.tableView.tableHeaderView = self.searchController.searchBar
    }
    
    func fetchUser() {
        let ref = FIRDatabase.database().reference().child("users")
        ref.observeEventType(.ChildAdded, withBlock: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User()
               
                user.id = snapshot.key
                user.setValuesForKeysWithDictionary(dictionary)
                self.users.append(user)
                self.filteredUsers.append(user)
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
            }
            }, withCancelBlock: nil)
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath)
        let user = filteredUsers[indexPath.row]
        cell.textLabel!.text = user.name
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    

    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchString:String = searchController.searchBar.text!
        
        self.filteredUsers = self.users.filter({ (user:User) -> Bool in
            let name = user.name
                let match = name!.rangeOfString(searchString)
                if (match != nil) {
                    return true
                } else {
                    return false
                }
        })
        self.tableView.reloadData()
    
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.filteredUsers = self.users
        self.tableView.reloadData()
    }
    
    func didDismissSearchController(searchController: UISearchController) {
        self.filteredUsers = self.users
        self.tableView.reloadData()
    }

}
