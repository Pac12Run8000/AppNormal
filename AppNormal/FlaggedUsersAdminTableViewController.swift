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
    var flagsDictionary = [String: Flag]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = ChatMessageCell.orangeishColor
        navigationController?.navigationBar.tintColor = ChatMessageCell.blackishColor
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(handelDismiss))
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellId)
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
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath)

        let flag = flags[indexPath.row]
        cell.textLabel?.text = flag.flaggedUserId
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flags.count
    }
    

}
