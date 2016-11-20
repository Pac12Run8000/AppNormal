//
//  FlaggedContentAdminViewController.swift
//  AppNormal
//
//  Created by Michelle Grover on 11/15/16.
//  Copyright © 2016 Norbert Grover. All rights reserved.
//

import UIKit
import Firebase

class FlaggedContentAdminViewController: UITableViewController {
    
   let cellId = "cellId"
    
    var flags = [Flag]()
    var flagsDictionary = [String:Flag]()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchFlags()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Users", style: .Plain, target: self, action: #selector(handleGetUsers))
        tableView.registerClass(FlagCell.self, forCellReuseIdentifier: cellId)
        navigationController?.navigationBar.tintColor = ChatMessageCell.blackishColor
        tableView.separatorColor = ChatMessageCell.orangeishColor
        tableView.allowsMultipleSelectionDuringEditing = true
        
    }
    
    func handleGetUsers() {
        let flaguseradminTableviewController = FlaggedUsersAdminTableViewController()
        let navController = UINavigationController(rootViewController: flaguseradminTableviewController)
        presentViewController(navController, animated: true, completion: nil)
    }
    
    func fetchFlags() {

        let ref = FIRDatabase.database().reference().child("flags")
        ref.observeEventType(.ChildAdded, withBlock: { (snapshot) in
           
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                let flagId = snapshot.key
                let flag = Flag(dictionary: dictionary)
                flag.flagId = flagId
                
                if (flag.flaggedPostId != nil) {
                    self.flags.append(flag)
                }
                
                dispatch_async(dispatch_get_main_queue(), { 
                    self.tableView.reloadData()
                })
                
                
            }
            }, withCancelBlock: nil)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        //print(indexPath.row)
        
        let flag = self.flags[indexPath.row]
        guard let flagId = flag.flagId, postId = flag.flaggedPostId else {
            return
        }
        
        let postRef = FIRDatabase.database().reference().child("feed").child(postId)
        postRef.removeValueWithCompletionBlock { (err, refer) in
            if (err != nil) {
                print("Problem with post removal: ", err)
                return
            }
            print("Post has been removed!!")
        }
        
        
        let flagRef = FIRDatabase.database().reference().child("flags").child(flagId)
        flagRef.removeValueWithCompletionBlock { (error, reff) in
            if (error != nil) {
                print("error: ", error)
                return
            }
            print("Flag has been removed!!")
            self.flags.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flags.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 190
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! FlagCell
        let flag = flags[indexPath.row]
        cell.flag = flag
       
        
        return cell
    }

}

    
    

