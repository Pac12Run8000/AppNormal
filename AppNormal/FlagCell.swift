//
//  FlagCell.swift
//  AppNormal
//
//  Created by Michelle Grover on 11/15/16.
//  Copyright © 2016 Norbert Grover. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation

class FlagCell: UITableViewCell {
    
    var flag: Flag? {
        didSet {
            
          self.complaintLabel.text = flag?.flagComplaint
            if let postId = flag?.flaggedPostId {
                let pRef = FIRDatabase.database().reference().child("feed").child(postId)
                pRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                    if let dictionary = snapshot.value as? [String:AnyObject] {
                        if let postImageUrl = dictionary["postImageUrl"] as? String {
                            self.postImageView.loadImageUsingCacheWithUrlString(postImageUrl)
                        }
                        if let videoUrl = dictionary["videoUrl"] as? String, url = NSURL(string: videoUrl) {
                            self.postImageView.image = self.generateThumnail(url, fromTime: Float64(1.22))
                        }
                    }
                    
                    
                    }, withCancelBlock: nil)
            }
            
            if let offenderId = flag?.flaggedUserId {
                let ref = FIRDatabase.database().reference().child("users").child(offenderId)
                ref.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                    if let dictionary = snapshot.value as? [String:AnyObject] {                        
                        self.offenderLabel.text = "offender: \(dictionary["name"] as! String)"
                        
                        if let profileImageUrl = dictionary["profileImageUrl"] as? String {
                            self.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
                        }
                        
                    }
                    }, withCancelBlock: nil)
                
                
            }
            if let accuserId = flag?.uId {
                let ref = FIRDatabase.database().reference().child("users").child(accuserId)
                ref.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                    if let dictionary = snapshot.value as? [String:AnyObject] {
                        self.accuserLabel.text = "accuser: \(dictionary["name"] as! String)"
                        
                        
                        
                    }
                    }, withCancelBlock: nil)
            }
            
        }
    }
    
    internal func generateThumnail(url : NSURL, fromTime:Float64) -> UIImage? {
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
    
    let postImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "default")
        imageView.backgroundColor = ChatMessageCell.orangeishColor
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 7
        imageView.contentMode = .ScaleAspectFit
        return imageView
    }()
    
    let profileImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "default")
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.blackColor().CGColor
        imageView.layer.cornerRadius = 25
        return imageView
    }()
    
    let offenderLabel:PaddingLabel = {
        let label = PaddingLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 5
        label.backgroundColor = ChatMessageCell.blackishColor
        label.textColor = UIColor.whiteColor()
        label.text = "offender:"
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 11)
        return label
    }()
    
    let accuserLabel:PaddingLabel = {
        let label = PaddingLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 5
        label.backgroundColor = ChatMessageCell.blackishColor
        label.textColor = UIColor.whiteColor()
        label.text = "accuser:"
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 11)
        return label
    }()
    
    let complaintLabel:UITextView = {
        let label = UITextView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)
        label.textColor = UIColor.whiteColor()
        label.text = "this is inappropriate ..."
        label.backgroundColor = ChatMessageCell.lightBrownishColor
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 4
       
        label.editable = false
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(postImageView)
        addSubview(profileImageView)
        addSubview(offenderLabel)
        addSubview(complaintLabel)
        addSubview(accuserLabel)
        
        self.backgroundColor = ChatMessageCell.browishColor
        
        
        
        complaintLabel.leftAnchor.constraintEqualToAnchor(profileImageView.rightAnchor, constant: 40).active = true
        complaintLabel.rightAnchor.constraintEqualToAnchor(self.rightAnchor, constant: -5).active = true
        complaintLabel.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 5).active = true
        complaintLabel.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor, constant: -5).active = true
        
        accuserLabel.topAnchor.constraintEqualToAnchor(offenderLabel.bottomAnchor, constant: 5).active = true
        accuserLabel.leftAnchor.constraintEqualToAnchor(self.leftAnchor, constant: 10).active = true
        accuserLabel.widthAnchor.constraintEqualToConstant(150).active = true
        accuserLabel.heightAnchor.constraintEqualToConstant(30).active = true
        
        offenderLabel.topAnchor.constraintEqualToAnchor(postImageView.bottomAnchor, constant: 5).active = true
        offenderLabel.leftAnchor.constraintEqualToAnchor(self.leftAnchor, constant: 10).active = true
        offenderLabel.widthAnchor.constraintEqualToConstant(150).active = true
        offenderLabel.heightAnchor.constraintEqualToConstant(30).active = true
        
        profileImageView.leftAnchor.constraintEqualToAnchor(postImageView.rightAnchor, constant: -10).active = true
        profileImageView.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 20).active = true
        profileImageView.widthAnchor.constraintEqualToConstant(50).active = true
        profileImageView.heightAnchor.constraintEqualToConstant(50).active = true
        
        postImageView.leftAnchor.constraintEqualToAnchor(self.leftAnchor, constant: 10).active = true
        postImageView.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 10).active = true
        postImageView.widthAnchor.constraintEqualToConstant(80).active = true
        postImageView.heightAnchor.constraintEqualToConstant(80).active = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
