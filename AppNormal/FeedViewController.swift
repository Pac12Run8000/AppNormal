//
//  FeedViewController.swift
//  AppNormal
//
//  Created by Michelle Grover on 10/4/16.
//  Copyright © 2016 Norbert Grover. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation
import MobileCoreServices


class FeedViewController: UITableViewController {
    
    let cellId = "cellId"
    
    var posts = [Post]()
    var postsDictionary = [String:Post]()


    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItemsAndBarButtons()
        checkIfUserLoggedInAndSetUpNavbarTitle()
        
        fetchPost()
        tableView.registerClass(PostCell.self, forCellReuseIdentifier: cellId)
        tableView.separatorColor = ChatMessageCell.orangeishColor
        tableView.backgroundColor = ChatMessageCell.lightBrownishColor
        
        
    }
    
    func fetchPost() {
        FIRDatabase.database().reference().child("feed").observeEventType(.ChildAdded, withBlock: { (snapshot) in
            //print(snapshot)
            let postId = snapshot.key
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let post = Post(dictionary: dictionary)
                post.postId = postId
                //post.setValuesForKeysWithDictionary(dictionary)
                self.posts.append(post)
                
                self.posts.sortInPlace({ (post1, post2) -> Bool in
                    return post1.timestamp?.intValue > post2.timestamp?.intValue
                })
//                *** This functionality makes it so that only one post from each user shows (Ep 10) ***
//                if let fromId = post.fromId {
//                    self.postsDictionary[fromId] = post
//                    
//                    self.posts = Array(self.postsDictionary.values)
//                }
                
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
        return 300
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //        let uId = posts[indexPath.row].fromId
        
        let postDetailController = PostDetailController()
        postDetailController.feedViewController = self
        
        let myPosts = posts[indexPath.row]
        postDetailController.post = myPosts
        navigationController?.pushViewController(postDetailController, animated: true)
    }
    
    
   
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! PostCell
        
        let post = posts[indexPath.row] 
        cell.post = post
        
        if let videoUrl = post.videoUrl {
            //cell.postImageView.image = UIImage(named: "addImage-3")
            let movieUrl:NSURL? = NSURL(string: videoUrl)
            cell.postImageView.image = generateThumnail(movieUrl!, fromTime:Float64(1.22))
        }
        return cell
    }
    
    func generateThumnail(url : NSURL, fromTime:Float64) -> UIImage? {
        let asset: AVAsset = AVAsset(URL: url)
        let assetImgGenerate: AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        assetImgGenerate.requestedTimeToleranceAfter = kCMTimeZero
        assetImgGenerate.requestedTimeToleranceBefore = kCMTimeZero
        
        do {
        let img: CGImageRef = try assetImgGenerate.copyCGImageAtTime(CMTimeMake(1, 60), actualTime: nil)
            let frameImg:UIImage = UIImage(CGImage: img)
            return frameImg
        } catch let err {
            print(err)
        }
       return nil
    }
    
    func setupNavigationItemsAndBarButtons() {
        navigationController?.navigationBar.barTintColor = ChatMessageCell.orangeishColor
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Compose, target: self, action: #selector(handleAddPostToFeed))
        navigationItem.leftBarButtonItem?.tintColor = ChatMessageCell.blackishColor
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Trash, target: self, action: #selector(handleDeleteFromFeed))
        navigationItem.rightBarButtonItem?.tintColor = ChatMessageCell.blackishColor
        
        if let font = UIFont(name: "Avenir-Heavy", size: 20) {
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
        super.drawTextInRect(CGRect(x: 10, y: 15, width: 300, height: 0))
    }
}

