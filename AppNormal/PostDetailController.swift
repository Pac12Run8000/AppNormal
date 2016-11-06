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
    var users = [User]()
    
    var post: Post? {
        didSet {
        
        }
    }
    
    var feedViewController: FeedViewController?
    
//    let activityIndicatorView: UIActivityIndicatorView = {
//        let aiv = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
//        aiv.translatesAutoresizingMaskIntoConstraints = false
//        aiv.hidesWhenStopped = true
//        
//        return aiv
//    }()
    
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
       

        label.userInteractionEnabled = false

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
    
    func handlePlay() {
        
        if let videoUrl = post?.videoUrl, url = NSURL(string: videoUrl) {
            let player = AVPlayer(URL: url)
            
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = postImageView.bounds
            postImageView.layer.addSublayer(playerLayer)
            player.play()
            
            //activityIndicatorView.startAnimating()
            playButton.hidden = true
           
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.whiteColor()
        commentField.text = post?.comment
        
        displayImagesAndText()
        
        
        mainContainer()
        
        
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
        if let videoUrl = post?.videoUrl {
            let url:NSURL? = NSURL(string: videoUrl)
            postImageView.image = feedViewController?.generateThumnail(url!, fromTime: Float64(1.22))
            
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
//        view.addSubview(activityIndicatorView)
//        
//        activityIndicatorView.centerXAnchor.constraintEqualToAnchor(postImageView.centerXAnchor).active = true
//        activityIndicatorView.centerYAnchor.constraintEqualToAnchor(postImageView.centerYAnchor).active = true
//        activityIndicatorView.widthAnchor.constraintEqualToConstant(65).active = true
//        activityIndicatorView.heightAnchor.constraintEqualToConstant(65).active = true

        
        
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
        
        
        
//        labelView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
//        labelView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
//        labelView.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
//
//        labelView.heightAnchor.constraintEqualToConstant(150).active = true
//        
//        commentLabel.centerXAnchor.constraintEqualToAnchor(labelView.centerXAnchor).active = true
//        commentLabel.centerYAnchor.constraintEqualToAnchor(labelView.centerYAnchor).active = true
//        commentLabel.widthAnchor.constraintEqualToAnchor(labelView.widthAnchor, constant: -15).active = true
//        commentLabel.heightAnchor.constraintEqualToAnchor(labelView.heightAnchor).active = true
//        
//        
//        postImageView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
//        postImageView.bottomAnchor.constraintEqualToAnchor(labelView.topAnchor, constant: -1).active = true
//        postImageView.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
//        postImageView.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 65).active = true
    }
    

}


