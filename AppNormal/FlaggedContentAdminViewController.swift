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
        
        tableView.registerClass(FlagCell.self, forCellReuseIdentifier: cellId)
        tableView.separatorColor = ChatMessageCell.orangeishColor
        
        
    }
    
    func fetchFlags() {

        let ref = FIRDatabase.database().reference().child("flags")
        ref.observeEventType(.ChildAdded, withBlock: { (snapshot) in
           
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                let flagId = snapshot.key
                let flag = Flag(dictionary: dictionary)
                flag.flagId = flagId
                self.flags.append(flag)
                
                dispatch_async(dispatch_get_main_queue(), { 
                    self.tableView.reloadData()
                })
                
                
            }
            }, withCancelBlock: nil)
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

    
    

