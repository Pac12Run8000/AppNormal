//
//  FlaggedUsersAdminTableViewController.swift
//  AppNormal
//
//  Created by Michelle Grover on 11/20/16.
//  Copyright © 2016 Norbert Grover. All rights reserved.
//

import UIKit
import Firebase

class FlaggedUsersAdminTableViewController: UITableViewController {
    
    let cellId = "cellId"
    
    var flags = [Flag]()
    var posts = [Post]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Flagged Users"
        navigationController?.navigationBar.barTintColor = ChatMessageCell.orangeishColor
        navigationController?.navigationBar.tintColor = ChatMessageCell.blackishColor
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(handelDismiss))
        tableView.registerClass(FlagCell.self, forCellReuseIdentifier: cellId)
        fetchFlags()
    }
    
    func fetchFlags() {
        
        let ref = FIRDatabase.database().reference().child("flags")
        ref.observeEventType(.ChildAdded, withBlock: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let flagId = snapshot.key
                let flag = Flag(dictionary: dictionary)
                flag.flagId = flagId
                
                if (flag.flaggedPostId == nil) {
                    self.flags.append(flag)
                }
                
                dispatch_async(dispatch_get_main_queue(), { 
                    self.tableView.reloadData()
                })
                
            }
            }, withCancelBlock: nil)
        
    }
    
    func handelDismiss() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 190
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as? FlagCell

        let flag = flags[indexPath.row]
        cell?.flag = flag
        //cell.textLabel?.text = flag.flaggedUserId
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        print(indexPath.row)
        
        let flag = self.flags[indexPath.row]
        
//        print(flag.flagId)
        
        guard let flagId = flag.flagId, flaggedUserId = flag.flaggedUserId else {
            return
        }

        let flagRef = FIRDatabase.database().reference().child("flags").child(flagId)
        flagRef.removeValueWithCompletionBlock { (error, refer) in
            if (error != nil) {
                print("error:", error)
                return
            }
            print("Post removed from flags")
        }
        
        let userRef = FIRDatabase.database().reference().child("users").child(flaggedUserId)
        userRef.removeValueWithCompletionBlock { (err, ref) in
            if (err != nil) {
                print("err:", err)
                return
            }
            print("User removed from flags")
        }
        
        print("Post not removed from Feed. Remove manually ...")
        
        self.flags.removeAtIndex(indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        
    }
    
    
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flags.count
    }
    

}
