//
//  FlagCell.swift
//  AppNormal
//
//  Created by Michelle Grover on 11/15/16.
//  Copyright © 2016 Norbert Grover. All rights reserved.
//

import UIKit
import Firebase

class FlagCell: UITableViewCell {
    
    var flag: Flag? {
        didSet {
        
        }
    }
    
    let postImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "default")
        imageView.backgroundColor = ChatMessageCell.orangeishColor
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 7
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
    
    let usernameLabel:PaddingLabel = {
        let label = PaddingLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 5
        label.backgroundColor = ChatMessageCell.blackishColor
        label.textColor = UIColor.whiteColor()
        label.text = "Sample user"
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)
        return label
    }()
    
    let complaintLabel:PaddingLabel = {
        let label = PaddingLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)
        label.textColor = UIColor.whiteColor()
        label.text = "this is inappropriate ..."
        label.backgroundColor = ChatMessageCell.lightBrownishColor
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 4
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(postImageView)
        addSubview(profileImageView)
        addSubview(usernameLabel)
        addSubview(complaintLabel)
        
        self.backgroundColor = ChatMessageCell.browishColor
        
        complaintLabel.leftAnchor.constraintEqualToAnchor(profileImageView.rightAnchor, constant: 20).active = true
        complaintLabel.rightAnchor.constraintEqualToAnchor(self.rightAnchor, constant: -5).active = true
        complaintLabel.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 5).active = true
        complaintLabel.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor, constant: -5).active = true
        
        usernameLabel.topAnchor.constraintEqualToAnchor(postImageView.bottomAnchor, constant: 5).active = true
        usernameLabel.leftAnchor.constraintEqualToAnchor(self.leftAnchor, constant: 10).active = true
        usernameLabel.widthAnchor.constraintEqualToConstant(150).active = true
        usernameLabel.heightAnchor.constraintEqualToConstant(30).active = true
        
        profileImageView.leftAnchor.constraintEqualToAnchor(postImageView.rightAnchor, constant: 10).active = true
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
