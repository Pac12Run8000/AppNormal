//
//  DeleteFromFeedController.swift
//  AppNormal
//
//  Created by Michelle Grover on 10/14/16.
//  Copyright © 2016 Norbert Grover. All rights reserved.
//

import UIKit
import Firebase

class DeletePostController: UITableViewController {
    
    let cellId = "cellId"
    
    var posts = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserLoggedInAndSetUpNavbarTitle()
        setUpNavBar()
        fetchPostsForDeletion()
        
        tableView.registerClass(PostCellForDelete.self, forCellReuseIdentifier: cellId)
    }
    
    
    func fetchPostsForDeletion() {
//        guard let uId = FIRAuth.auth()?.currentUser?.uid else {
//            return
//        }
        let ref = FIRDatabase.database().reference().child("feed")
        ref.observeEventType(.ChildAdded, withBlock: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String:AnyObject] {
                let post = Post()
                post.setValuesForKeysWithDictionary(dictionary)
                self.posts.append(post)
                
                dispatch_async(dispatch_get_main_queue(), { 
                    self.tableView.reloadData()
                })
                
            }
            }, withCancelBlock: nil)
       
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "cellId") as! PostCellForDelete
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! PostCellForDelete
        let post = posts[indexPath.row]
        cell.commentLabel.text = post.comment
        
        if let postImageView = post.postImageUrl {
            cell.postImageView.loadImageUsingCacheWithUrlString(postImageView)
        }
        
        return cell
    }
    
    
    
    
    func checkIfUserLoggedInAndSetUpNavbarTitle() {
        if (FIRAuth.auth()?.currentUser?.uid == nil) {
            performSelector(#selector(handleLogOut), withObject: nil, afterDelay: 0)
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
    
    func setUpNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(handleCancel))
        navigationItem.leftBarButtonItem?.tintColor = ChatMessageCell.blackishColor
        navigationController?.navigationBar.barTintColor = ChatMessageCell.orangeishColor
        navigationItem.title = "Delete Posts"
        if let font = UIFont(name: "Avenir-Heavy", size: 18) {
            navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: font]
        }
    }
    
    func handleCancel() {
        dismissViewControllerAnimated(true, completion: nil)
    }

    
}

class DeletePostCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}

class PostCellForDelete: UITableViewCell {
    
    let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "default")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .ScaleToFill
        imageView.backgroundColor = UIColor.brownColor()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 35
        return imageView
    }()
    
    let commentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 20)
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(postImageView)
        addSubview(commentLabel)
        
        commentLabel.leftAnchor.constraintEqualToAnchor(postImageView.rightAnchor, constant: 20).active = true
        commentLabel.centerYAnchor.constraintEqualToAnchor(self.centerYAnchor).active = true
        commentLabel.widthAnchor.constraintEqualToConstant(100).active = true
        commentLabel.heightAnchor.constraintEqualToConstant(50).active = true
        
        
        postImageView.leftAnchor.constraintEqualToAnchor(self.leftAnchor, constant: 20).active = true
        postImageView.centerYAnchor.constraintEqualToAnchor(self.centerYAnchor).active = true
        postImageView.heightAnchor.constraintEqualToConstant(70).active = true
        postImageView.widthAnchor.constraintEqualToConstant(70).active = true
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
