//
//  DeleteFromFeedController.swift
//  AppNormal
//
//  Created by Michelle Grover on 10/14/16.
//  Copyright © 2016 Norbert Grover. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation
import MobileCoreServices

class DeletePostController: UITableViewController {
    
    let cellId = "cellId"
   

    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserLoggedInAndSetUpNavbarTitle()
        setUpNavBar()
        fetchPostsForDeletion()
        
        tableView.registerClass(PostCellForDelete.self, forCellReuseIdentifier: cellId)
        tableView.allowsMultipleSelectionDuringEditing = true
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let post = self.posts[indexPath.row]
        guard let postId = post.postId else {
            return
        }
        
            let ref = FIRDatabase.database().reference().child("feed").child(postId)
            ref.removeValueWithCompletionBlock { (error, reff) in
                if (error != nil) {
                    print("error:", error)
                    return
                }
                self.posts.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    var posts = [Post]()
    var postsDictionary = [String: Post]()
    
    func fetchPostsForDeletion() {
        guard let uId = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        let ref = FIRDatabase.database().reference().child("feed")
        ref.observeEventType(.ChildAdded, withBlock: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String:AnyObject] {
                let post = Post(dictionary: dictionary)
                post.postId = snapshot.key
                post.setValuesForKeysWithDictionary(dictionary)
//                if let fromId = post.fromId {
//                    self.postsDictionary[fromId] = post
//                }
                //Ep 10 Hows to Group messages per user
                if (uId == dictionary["fromId"] as? String) {
                    self.posts.append(post)
//                    if let postId = post.fromId {
//                        self.postsDictionary[postId] = post
//                        self.posts = Array(self.postsDictionary.values)
//                    }
                }
               
               
                
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
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! PostCellForDelete
        let post = posts[indexPath.row]
        
       
            if let fromId = post.fromId {
                let ref = FIRDatabase.database().reference().child("users").child(fromId)
                ref.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                    if let dictionary = snapshot.value as? [String:AnyObject] {
                        if let profileImageUrl = dictionary["profileImageUrl"] as? String {
                            cell.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
                        }
                        
                    }
                    }, withCancelBlock: nil)
            
            }
        if let timestamp = post.timestamp {
            cell.timestampLabel.text = getDateFormat(timestamp)            
        }
        
        cell.commentLabel.text = post.comment
        cell.backgroundColor = ChatMessageCell.lightBrownishColor
        
        if let postImageView = post.postImageUrl {
            cell.postImageView.loadImageUsingCacheWithUrlString(postImageView)
        }
        if let videoUrl = post.videoUrl, url = NSURL(string: videoUrl) {
            cell.postImageView.image = generateThumbNail(url, fromTime:Float64(1.22))
        }
        
        return cell
    }
    
    func generateThumbNail(url:NSURL, fromTime:Float64) -> UIImage? {
        let asset:AVAsset = AVAsset(URL: url)
        let assetImageGenerate:AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
        assetImageGenerate.appliesPreferredTrackTransform = true
        assetImageGenerate.requestedTimeToleranceAfter = kCMTimeZero
        assetImageGenerate.requestedTimeToleranceBefore = kCMTimeZero
        
        do {
            let img: CGImageRef = try assetImageGenerate.copyCGImageAtTime(CMTimeMake(1, 60), actualTime: nil)
            let frameImg:UIImage = UIImage(CGImage: img)
            return frameImg
        } catch let err {
            print(err)
        }
        
        return nil
    }
    
//    func generateThumnail(url : NSURL, fromTime:Float64) -> UIImage? {
//        let asset: AVAsset = AVAsset(URL: url)
//        let assetImgGenerate: AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
//        assetImgGenerate.appliesPreferredTrackTransform = true
//        assetImgGenerate.requestedTimeToleranceAfter = kCMTimeZero
//        assetImgGenerate.requestedTimeToleranceBefore = kCMTimeZero
//        
//        do {
//            let img: CGImageRef = try assetImgGenerate.copyCGImageAtTime(CMTimeMake(1, 60), actualTime: nil)
//            let frameImg:UIImage = UIImage(CGImage: img)
//            return frameImg
//        } catch let err {
//            print(err)
//        }
//        return nil
//    }
    
    func getDateFormat(timestamp:NSNumber) -> String {
        
        let seconds = timestamp.doubleValue
        let timeStampDate = NSDate(timeIntervalSince1970: seconds)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "hh:mm:ss a"
        let timeVal = dateFormatter.stringFromDate(timeStampDate)
        
        return timeVal
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
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "default")
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 15
        imageView.layer.borderColor = ChatMessageCell.orangeishColor.CGColor
        imageView.layer.borderWidth = 2
        return imageView
    }()
    
    let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "default")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .ScaleToFill
        imageView.backgroundColor = UIColor.brownColor()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 35
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.whiteColor().CGColor
        return imageView
    }()
    
    let commentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)
//        label.backgroundColor = UIColor.lightGrayColor()
        label.textColor = UIColor.whiteColor()
        return label
    }()
    
    let timestampLabel:PaddingLabel = {
        let label = PaddingLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = ChatMessageCell.orangeishColor
        label.textColor = UIColor.whiteColor()
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 15
        label.text = "HH:MM:SS"
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 10)
        //name: "Avenir-Heavy", size: 18
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(postImageView)
        addSubview(commentLabel)
        addSubview(profileImageView)
        addSubview(timestampLabel)
        
        timestampLabel.rightAnchor.constraintEqualToAnchor(self.rightAnchor, constant: -20).active = true
        timestampLabel.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 5).active = true
        timestampLabel.widthAnchor.constraintEqualToConstant(100).active = true
        timestampLabel.heightAnchor.constraintEqualToConstant(30).active = true
        
        profileImageView.leftAnchor.constraintEqualToAnchor(postImageView.rightAnchor, constant: -15).active = true
        profileImageView.topAnchor.constraintEqualToAnchor(postImageView.topAnchor, constant: -5).active = true
        profileImageView.widthAnchor.constraintEqualToConstant(30).active = true
        profileImageView.heightAnchor.constraintEqualToConstant(30).active = true
        
        commentLabel.leftAnchor.constraintEqualToAnchor(postImageView.rightAnchor, constant: 20).active = true
        commentLabel.centerYAnchor.constraintEqualToAnchor(self.centerYAnchor).active = true
        commentLabel.widthAnchor.constraintEqualToConstant(240).active = true
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
