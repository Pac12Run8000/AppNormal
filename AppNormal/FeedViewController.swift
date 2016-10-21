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
    var users = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItemsAndBarButtons()
        checkIfUserLoggedInAndSetUpNavbarTitle()
        
        tableView.registerClass(PostCell.self, forCellReuseIdentifier: cellId)
        
        tableView.separatorColor = ChatMessageCell.orangeishColor
        tableView.backgroundColor = ChatMessageCell.lightBrownishColor
        fetchPost()
        
    }
    
    func fetchPost() {
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
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 275
    }
    
    
   
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! PostCell
        let post = posts[indexPath.row]
        cell.commentLabel.text = post.comment
        
//        cell.detailTextLabel?.text = post.fromId


        
        if let postImageUrl = post.postImageUrl {
            cell.postImageView.loadImageUsingCacheWithUrlString(postImageUrl)
        }
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

class PaddingLabel: UILabel {
    override func drawTextInRect(rect: CGRect) {
        super.drawTextInRect(CGRect(x: 10, y: 20, width: 300, height: 0))
    }
}

class PostCell: UITableViewCell {
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        
//        textLabel?.frame = CGRectMake(85, textLabel!.frame.origin.y + 100, textLabel!.frame.width, textLabel!.frame.height)
//        detailTextLabel?.frame = CGRectMake(85, detailTextLabel!.frame.origin.y + 100, detailTextLabel!.frame.width, detailTextLabel!.frame.height)
//    }
    
  
    
    let commentLabel: PaddingLabel = {
        var label = PaddingLabel()
        label.backgroundColor = ChatMessageCell.orangeishColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 7
        label.layer.borderWidth = 2
        label.layer.backgroundColor = ChatMessageCell.blackishColor.CGColor
        //label.numberOfLines = 5
        
        return label
    
    }()
    
    let userIcon: UIImageView = {
        let imgVw = UIImageView()
        imgVw.translatesAutoresizingMaskIntoConstraints = false
        imgVw.image = UIImage(named: "default")
        imgVw.layer.masksToBounds = true
        imgVw.layer.cornerRadius = 20
        imgVw.layer.borderWidth = 2
        imgVw.layer.borderColor = ChatMessageCell.blackishColor.CGColor
        return imgVw
    }()
    
    let postImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "default")
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.layer.masksToBounds = true
        imgView.layer.cornerRadius = 9
        imgView.contentMode = .ScaleAspectFill
        return imgView
    }()
    
    let padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
        
        
        addSubview(postImageView)
        
        addSubview(commentLabel)
        
        addSubview(userIcon)
        
        commentLabel.leftAnchor.constraintEqualToAnchor(postImageView.leftAnchor).active = true
        commentLabel.topAnchor.constraintEqualToAnchor(postImageView.bottomAnchor, constant: 20).active = true
        commentLabel.widthAnchor.constraintEqualToAnchor(postImageView.widthAnchor).active = true
        commentLabel.heightAnchor.constraintEqualToConstant(40).active = true
        
        
        
        userIcon.topAnchor.constraintEqualToAnchor(postImageView.bottomAnchor, constant: -10).active = true
        userIcon.leftAnchor.constraintEqualToAnchor(postImageView.leftAnchor).active = true
        userIcon.widthAnchor.constraintEqualToConstant(40).active = true
        userIcon.heightAnchor.constraintEqualToConstant(40).active = true
        
        postImageView.leftAnchor.constraintEqualToAnchor(self.leftAnchor, constant: 20).active = true
        postImageView.centerYAnchor.constraintEqualToAnchor(self.centerYAnchor, constant: -30).active = true
        postImageView.widthAnchor.constraintEqualToAnchor(self.widthAnchor, constant: -40).active = true
        postImageView.heightAnchor.constraintEqualToConstant(200).active = true
        

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
