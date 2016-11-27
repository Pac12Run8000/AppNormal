//
//  SettingsViewController.swift
//  AppNormal
//
//  Created by Michelle Grover on 11/26/16.
//  Copyright © 2016 Norbert Grover. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {
    
    let deletButton:UIButton = {
        let button = UIButton(type: UIButtonType.System)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Delete Account", forState: UIControlState.Normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.backgroundColor = ChatMessageCell.redishColor
        button.tintColor = UIColor.blackColor()
        button.layer.borderColor = ChatMessageCell.orangeishColor.CGColor
        button.layer.borderWidth = 3
        button
        return button
    }()
   
    
    let userNameLabel:PaddingLabel = {
        let label = PaddingLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = ChatMessageCell.orangeishColor
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 5
        label.layer.borderColor = UIColor.whiteColor().CGColor
        label.layer.borderWidth = 2
        label.textAlignment = .Center
        
        return label
    }()
    
    let instructionLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = ChatMessageCell.redishColor
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        label.text = "click on the profileImage\n or username to edit"
        label.textAlignment = .Center
        label.numberOfLines = 4
        return label
    }()
    
    
    let profileImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "default")
        imageView.layer.borderColor = UIColor.whiteColor().CGColor
        imageView.layer.borderWidth = 2
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 50
        return imageView
    }()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        fetchUser()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = ChatMessageCell.orangeishColor
        view.backgroundColor = ChatMessageCell.browishColor
        
        
        setUpConstraints()
       
    }
    
    func fetchUser() {
       
        if let uId = FIRAuth.auth()?.currentUser?.uid {
       
        
        let ref = FIRDatabase.database().reference().child("users").child(uId)
        ref.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
                let user = User()
                
                user.id = snapshot.key
                user.setValuesForKeysWithDictionary(dictionary)
                
                if let profileImageUrl = user.profileImageUrl {
                    self.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
                }
                
                self.userNameLabel.text = user.name
                
            }
            }, withCancelBlock: nil)
        }
       
    }
    

    func setUpConstraints() {
        view.addSubview(profileImageView)
        view.addSubview(userNameLabel)
        view.addSubview(instructionLabel)
        view.addSubview(deletButton)
        
        deletButton.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        deletButton.topAnchor.constraintEqualToAnchor(instructionLabel.bottomAnchor, constant: 10).active = true
        deletButton.widthAnchor.constraintEqualToAnchor(view.widthAnchor, constant: -40).active = true
        deletButton.heightAnchor.constraintEqualToConstant(50).active = true
        
        
        instructionLabel.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        instructionLabel.topAnchor.constraintEqualToAnchor(userNameLabel.bottomAnchor, constant: 10).active = true
        instructionLabel.widthAnchor.constraintEqualToAnchor(view.widthAnchor, constant: -30).active = true
        instructionLabel.heightAnchor.constraintEqualToConstant(80).active = true
        
        userNameLabel.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        userNameLabel.topAnchor.constraintEqualToAnchor(profileImageView.bottomAnchor, constant: 10).active = true
        userNameLabel.widthAnchor.constraintEqualToAnchor(view.widthAnchor, constant: -30).active = true
        userNameLabel.heightAnchor.constraintEqualToConstant(30).active = true
        
        profileImageView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        profileImageView.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 100).active = true
        profileImageView.widthAnchor.constraintEqualToConstant(130).active = true
        profileImageView.heightAnchor.constraintEqualToConstant(130).active = true
    }
    
    

    

}
