//
//  PostCell.swift
//  AppNormal
//
//  Created by Michelle Grover on 10/28/16.
//  Copyright © 2016 Norbert Grover. All rights reserved.
//


import UIKit
import Firebase

class PostCell: UITableViewCell {
    
    var post: Post? {
        didSet {
            
            if let fromId = post?.fromId {
                let ref = FIRDatabase.database().reference().child("users").child(fromId)
                ref.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                    
                    if let dictionary = snapshot.value as? [String:AnyObject] {
                        self.userNamelabel.text = dictionary["name"] as? String
                        
                        if let profileImageUrl = dictionary["profileImageUrl"] as? String {
                            self.userIcon.loadImageUsingCacheWithUrlString(profileImageUrl)
                        }
                    }
                    }, withCancelBlock: nil)
                
            }            
            self.commentLabel.text = post?.comment            
            
            if let seconds = post?.timestamp?.doubleValue {
                let timestampDate = NSDate(timeIntervalSince1970: seconds)
                
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "hh:mm:ss a"
                dateTimeLabel.text = dateFormatter.stringFromDate(timestampDate)
            }
            
            
           
            if let postImageUrl = post?.postImageUrl {
                postImageView.loadImageUsingCacheWithUrlString(postImageUrl)
            }
        }
    }
    
    //    override func layoutSubviews() {
    //        super.layoutSubviews()
    //
    //        textLabel?.frame = CGRectMake(85, textLabel!.frame.origin.y + 100, textLabel!.frame.width, textLabel!.frame.height)
    //        detailTextLabel?.frame = CGRectMake(85, detailTextLabel!.frame.origin.y + 100, detailTextLabel!.frame.width, detailTextLabel!.frame.height)
    //    }
    
    let userNamelabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        //        label.text = "user test 1"
        label.textColor = ChatMessageCell.redishColor
        //        label.backgroundColor = UIColor.lightGrayColor()
        return label
    }()
    
    let dateTimeLabel:PaddingLabel = {
        let label = PaddingLabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.whiteColor()
        label.backgroundColor = ChatMessageCell.orangeishColor
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 10
        return label
    }()
    
    
    let commentLabel: PaddingLabel = {
        var label = PaddingLabel()
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 12)
        label.layer.borderWidth = 1
        
        //label.numberOfLines = 5
        
        return label
        
    }()
    
    //User Icon is hidden for now
    let userIcon: UIImageView = {
        let imgVw = UIImageView()
        imgVw.hidden = false
        imgVw.translatesAutoresizingMaskIntoConstraints = false
        imgVw.image = UIImage(named: "default")
        imgVw.layer.masksToBounds = true
        imgVw.layer.cornerRadius = 20
        imgVw.layer.borderWidth = 2
        imgVw.layer.borderColor = ChatMessageCell.orangeishColor.CGColor
        return imgVw
    }()
    
    let postImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "default")
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.layer.masksToBounds = true
        
        imgView.contentMode = .ScaleAspectFill
        return imgView
    }()
    
    let padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
        
        
        addSubview(postImageView)
        
        addSubview(commentLabel)
        
        addSubview(userIcon)
        
        addSubview(dateTimeLabel)
        
        addSubview(userNamelabel)
        
        userNamelabel.leftAnchor.constraintEqualToAnchor(userIcon.rightAnchor, constant: 10).active = true
        userNamelabel.bottomAnchor.constraintEqualToAnchor(commentLabel.topAnchor, constant: 0).active = true
        userNamelabel.widthAnchor.constraintEqualToConstant(150).active = true
        userNamelabel.topAnchor.constraintEqualToAnchor(postImageView.bottomAnchor, constant: 0).active = true
        
        dateTimeLabel.rightAnchor.constraintEqualToAnchor(self.rightAnchor, constant: -20).active = true
        dateTimeLabel.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 20).active = true
        dateTimeLabel.widthAnchor.constraintEqualToConstant(150).active = true
        dateTimeLabel.heightAnchor.constraintEqualToConstant(30).active = true
        
        
        commentLabel.leftAnchor.constraintEqualToAnchor(postImageView.leftAnchor).active = true
        commentLabel.topAnchor.constraintEqualToAnchor(postImageView.bottomAnchor, constant: 30).active = true
        commentLabel.widthAnchor.constraintEqualToAnchor(postImageView.widthAnchor).active = true
        commentLabel.heightAnchor.constraintEqualToConstant(40).active = true
        
        
        
        userIcon.topAnchor.constraintEqualToAnchor(postImageView.bottomAnchor, constant: -15).active = true
        userIcon.leftAnchor.constraintEqualToAnchor(postImageView.leftAnchor).active = true
        userIcon.widthAnchor.constraintEqualToConstant(40).active = true
        userIcon.heightAnchor.constraintEqualToConstant(40).active = true
        
        postImageView.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor).active = true
        postImageView.topAnchor.constraintEqualToAnchor(self.topAnchor).active = true
        postImageView.widthAnchor.constraintEqualToAnchor(self.widthAnchor).active = true
        postImageView.heightAnchor.constraintEqualToConstant(220).active = true
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
