//
//  PostDetailController.swift
//  AppNormal
//
//  Created by Michelle Grover on 10/21/16.
//  Copyright © 2016 Norbert Grover. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation

class PostDetailController: UIViewController {
    
    var post: Post? {
        didSet {
        
        }
    }
    
    var like:Bool = false
    var feedViewController: FeedViewController?
    
    let dateTimeLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.Center
        label.backgroundColor = ChatMessageCell.lightBrownishColor
        label.textColor = ChatMessageCell.orangeishColor
        return label
    }()
    
    let labelView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 1
        return view
    }()
    
    let commentField:UITextView = {
        let label = UITextView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        
        label.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 12)
       
        label.contentInset = UIEdgeInsetsMake(-30.0,0.0,0,0.0)
        label.userInteractionEnabled = false
//        label.backgroundColor = UIColor.grayColor()
        return label
    }()
    
    let postImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "default")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = ChatMessageCell.orangeishColor
        imageView.contentMode = .ScaleAspectFit
        return imageView
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "default")
        imageView.layer.cornerRadius = 30
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = ChatMessageCell.orangeishColor.CGColor
        imageView.layer.borderWidth = 2
        
        return imageView
    }()
    
    lazy var playButton:UIButton = {
        let button = UIButton(type: .System)
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "play_button_2")
        button.tintColor = UIColor.whiteColor()
        button.setImage(image, forState: .Normal)
        button.hidden = false
        button.addTarget(self, action: #selector(handlePlay), forControlEvents: .TouchUpInside)
        return button
    }()
    

    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.hidesWhenStopped = true
        //        aiv.startAnimating()
        return aiv
    }()
    
    let videoActivityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.hidesWhenStopped = true
        return view
    }()
    
    lazy var flagButton:UIButton = {
        let button = UIButton(type: UIButtonType.System)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("[Flag]", forState: .Normal)
        button.setTitleColor(ChatMessageCell.orangeishColor, forState: UIControlState.Normal)
        button.addTarget(self, action: #selector(flagContent), forControlEvents: .TouchUpInside)
        return button
    }()
    
    lazy var likeButton:UIButton = {
        let button = UIButton(type: UIButtonType.System)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Like", forState: UIControlState.Normal)
        button.backgroundColor = ChatMessageCell.browishColor
        button.setTitleColor(ChatMessageCell.orangeishColor, forState: UIControlState.Normal)
        button.layer.cornerRadius = 4
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handleLike), forControlEvents: .TouchUpInside)
        return button
    }()
    
    
    var playeLayer: AVPlayerLayer?
    var player: AVPlayer?
    
    func handleLike() {
        
        guard let uId = FIRAuth.auth()?.currentUser?.uid, postId = post?.postId else {
            return
        }
        
        if (like == false) {
            like = true
            likeButton.backgroundColor = ChatMessageCell.orangeishColor
            likeButton.setTitleColor(ChatMessageCell.browishColor, forState: UIControlState.Normal)
        } else {
            like = false
            likeButton.backgroundColor = ChatMessageCell.browishColor
            likeButton.setTitleColor(ChatMessageCell.orangeishColor, forState: UIControlState.Normal)
        }

        
        
        print(like)
        
        let ref = FIRDatabase.database().reference().child("likes")
        let childRef = ref.child(uId + "-" + postId)
        
        let values:[String:AnyObject] = ["uId": uId, "postId": postId, "like":like]
        
        childRef.updateChildValues(values) { (error, refer) in
            if (error != nil) {
                print(error)
                return
            }
            print("Like added!")
        }
        
    }
    
    func flagContent() {
        let flagPost = post
        let flagcontentViewController = FlagContentViewController()
        flagcontentViewController.post = flagPost
        let navController = UINavigationController(rootViewController: flagcontentViewController)
        presentViewController(navController, animated: true, completion: nil)
    }

    
    func handlePlay() {
        
        if let videoUrl = post?.videoUrl, url = NSURL(string: videoUrl) {
            player = AVPlayer(URL: url)
            playeLayer = AVPlayerLayer(player: player)
            playeLayer?.frame = postImageView.bounds
            postImageView.layer.addSublayer(playeLayer!)

            
            playButton.hidden = true
            player?.play()
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.whiteColor()
        commentField.text = post?.comment
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: #selector(sharePost))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.blackColor()
        
        
        displayImagesAndText()
        
        
        mainContainer()
        
        
    }
    
    func sharePost() {
        let vc = UIActivityViewController(activityItems: [postImageView.image!, commentField.text], applicationActivities: nil)
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func displayImagesAndText() {
        if let userId = post?.fromId {
            let ref = FIRDatabase.database().reference().child("users").child(userId)
            ref.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                if let dictionary = snapshot.value as? [String:AnyObject] {
                    if let profileImageUrl = dictionary["profileImageUrl"] as? String {
                        self.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
                    }
                 }
                }, withCancelBlock: nil)
        }
        
        if let postImage = post?.postImageUrl {
            postImageView.loadImageUsingCacheWithUrlString(postImage)
        }
        
        if let timestamp = post?.timestamp {
             dateTimeLabel.text = getDateFormat(timestamp)
        }
        if let videoUrl = post?.videoUrl, url = NSURL(string:videoUrl) {
            postImageView.image = feedViewController?.generateThumnail(url, fromTime: Float64(1.22))
        }
       playButton.hidden = post?.videoUrl == nil
    }
    
    func getDateFormat(timestamp:NSNumber) -> String {
    
        let seconds = timestamp.doubleValue
        let timeStampDate = NSDate(timeIntervalSince1970: seconds)
    
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "hh:mm:ss a"
        let timeVal = dateFormatter.stringFromDate(timeStampDate)
    
        return timeVal
    }
    
   

    func mainContainer() {
        view.addSubview(labelView)
        labelView.addSubview(commentField)
        view.addSubview(postImageView)
        view.addSubview(dateTimeLabel)
        view.addSubview(profileImageView)
        view.addSubview(playButton)
        view.addSubview(videoActivityIndicatorView)
        view.addSubview(flagButton)
        view.addSubview(likeButton)
        
        likeButton.topAnchor.constraintEqualToAnchor(commentField.topAnchor, constant: 5).active = true
        likeButton.rightAnchor.constraintEqualToAnchor(view.rightAnchor, constant: -10).active = true
        likeButton.widthAnchor.constraintEqualToConstant(60).active = true
        likeButton.heightAnchor.constraintEqualToConstant(30).active = true
        
        flagButton.rightAnchor.constraintEqualToAnchor(view.rightAnchor).active = true
        flagButton.topAnchor.constraintEqualToAnchor(dateTimeLabel.topAnchor).active = true
        flagButton.widthAnchor.constraintEqualToConstant(100).active = true
        flagButton.heightAnchor.constraintEqualToConstant(30).active = true
        
        
        videoActivityIndicatorView.centerXAnchor.constraintEqualToAnchor(postImageView.centerXAnchor).active = true
        videoActivityIndicatorView.centerYAnchor.constraintEqualToAnchor(postImageView.centerYAnchor).active = true
        videoActivityIndicatorView.widthAnchor.constraintEqualToConstant(60).active = true
        videoActivityIndicatorView.heightAnchor.constraintEqualToConstant(60).active = true

        
        
        playButton.centerXAnchor.constraintEqualToAnchor(postImageView.centerXAnchor).active = true
        playButton.centerYAnchor.constraintEqualToAnchor(postImageView.centerYAnchor).active = true
        playButton.widthAnchor.constraintEqualToConstant(65).active = true
        playButton.heightAnchor.constraintEqualToConstant(50).active = true
        
        profileImageView.leftAnchor.constraintEqualToAnchor(view.leftAnchor, constant: 20).active = true
        profileImageView.bottomAnchor.constraintEqualToAnchor(labelView.topAnchor, constant: 20).active = true
        profileImageView.widthAnchor.constraintEqualToConstant(60).active = true
        profileImageView.heightAnchor.constraintEqualToConstant(60).active = true
        
        dateTimeLabel.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        dateTimeLabel.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 65).active = true
        dateTimeLabel.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        dateTimeLabel.heightAnchor.constraintEqualToConstant(30).active = true
        
        
        labelView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        labelView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor, constant: -50).active = true
        labelView.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        labelView.heightAnchor.constraintEqualToConstant(200).active = true
        
        commentField.centerXAnchor.constraintEqualToAnchor(labelView.centerXAnchor).active = true
        commentField.centerYAnchor.constraintEqualToAnchor(labelView.centerYAnchor).active = true
        commentField.widthAnchor.constraintEqualToAnchor(labelView.widthAnchor, constant: -20).active = true
        commentField.heightAnchor.constraintEqualToAnchor(labelView.heightAnchor).active = true
        
        postImageView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        postImageView.bottomAnchor.constraintEqualToAnchor(commentField.topAnchor).active = true
        postImageView.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        postImageView.topAnchor.constraintEqualToAnchor(dateTimeLabel.bottomAnchor).active = true
        
        
    }
    

}


