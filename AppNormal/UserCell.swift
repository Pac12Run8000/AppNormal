//
//  UserCell.swift
//  AppNormal
//
//  Created by Michelle Grover on 10/8/16.
//  Copyright © 2016 Norbert Grover. All rights reserved.
//

import UIKit
import Firebase

class UserCell: UITableViewCell {
    
    var message: Message? {
        didSet {
            setUpNameAndProfileImage()
            
            detailTextLabel?.text = message?.text
            if let seconds = message?.timestamp?.doubleValue {
                let timestampDate = NSDate(timeIntervalSince1970: seconds)
                
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "hh:mm:ss a"
                
                timeLabel.text = dateFormatter.stringFromDate(timestampDate)
            }
            
            
            
        }
    }
    
    private func setUpNameAndProfileImage() {
        let chatPartnerId:String?
        
        if message?.fromId == FIRAuth.auth()?.currentUser?.uid {
            chatPartnerId = message?.toId
        } else {
            chatPartnerId = message?.fromId
        }
        
        
        if let id = chatPartnerId {
            let ref = FIRDatabase.database().reference().child("users").child(id)
            ref.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                if let dictionary = snapshot.value as? [String:AnyObject] {
                    
                    self.textLabel?.text = dictionary["name"] as? String
                    
                    if let profileImageUrl = dictionary["profileImageUrl"] as? String {
                        self.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
                    }
                    
                }
                }, withCancelBlock: nil)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRectMake(72, textLabel!.frame.origin.y - 2, textLabel!.frame.width, textLabel!.frame.height)
        detailTextLabel?.frame = CGRectMake(72, detailTextLabel!.frame.origin.y + 2, detailTextLabel!.frame.width, detailTextLabel!.frame.height)
        textLabel?.textColor = UIColor(red: 1.00, green: 0.53, blue: 0.14, alpha: 1.0)
        detailTextLabel?.textColor = UIColor(red: 1.00, green: 0.53, blue: 0.14, alpha: 1.0)
        backgroundColor = UIColor(red: 0.17, green: 0.05, blue: 0.00, alpha: 1.0)
    }
    
    let timeLabel:UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 1.00, green: 0.53, blue: 0.14, alpha: 1.0)
        
        label.font = UIFont.systemFontOfSize(12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    
    }()
    
    let profileImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.layer.masksToBounds = true
        imgView.layer.cornerRadius = 24
        imgView.layer.borderColor = UIColor(red: 1.00, green: 0.53, blue: 0.14, alpha: 1.0).CGColor
        imgView.layer.borderWidth = 2
        imgView.contentMode = .ScaleAspectFill
        return imgView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        addSubview(timeLabel)
        
        timeLabel.rightAnchor.constraintEqualToAnchor(self.rightAnchor).active = true
        timeLabel.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 10).active = true
        timeLabel.widthAnchor.constraintEqualToConstant(100).active = true
        timeLabel.heightAnchor.constraintEqualToAnchor(textLabel?.heightAnchor).active = true
        
        profileImageView.leftAnchor.constraintEqualToAnchor(self.leftAnchor, constant: 10).active = true
        profileImageView.centerYAnchor.constraintEqualToAnchor(self.centerYAnchor).active = true
        profileImageView.widthAnchor.constraintEqualToConstant(48).active = true
        profileImageView.heightAnchor.constraintEqualToConstant(48).active = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
