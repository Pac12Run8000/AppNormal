//
//  FlagUserViewController.swift
//  AppNormal
//
//  Created by Michelle Grover on 11/18/16.
//  Copyright © 2016 Norbert Grover. All rights reserved.
//

import UIKit
import Firebase

class FlagUserViewController: UIViewController {

    var user: User? {
        didSet {
            navigationItem.title = "Flag User"
            if let profileImageUrl = user?.profileImageUrl {
                self.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
            }
            nameLabel.text = user?.name
        }
    }
    
    let profileImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "default")
        imageView.backgroundColor = ChatMessageCell.orangeishColor
        imageView.layer.cornerRadius = 75
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = ChatMessageCell.orangeishColor.CGColor
        imageView.layer.borderWidth = 3
        return imageView
    }()
    
    let instructionLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12)
        let instruction = "It is the duty for all members of this community to report people who violate the dignity of other community members. Online harrassment, stalking, racial epithets and trolling of any kind will not be tolerated on this forum."
        label.textColor = UIColor.whiteColor()
//        label.backgroundColor = UIColor.grayColor()
        label.text = instruction
        label.numberOfLines = 10
//        label.layer.borderWidth = 2
        return label
    }()
    
    let nameLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 26)
        label.textColor = ChatMessageCell.orangeishColor
//        label.layer.borderWidth = 2
        return label
    }()
    
    let complaintTextView:UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12)
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationControllers()
        view.backgroundColor = ChatMessageCell.lightBrownishColor
        setUpView()
        
        
    }
    
    func setUpNavigationControllers() {
        navigationController?.navigationBar.barTintColor = ChatMessageCell.orangeishColor
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(handleDismiss))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: #selector(handeSaveFlag))
    }
    
    func handeSaveFlag() {
        guard let uId = FIRAuth.auth()?.currentUser?.uid, flaggedUserId = user?.id, flagComplaint = complaintTextView.text else {
            return
        }
        
        let values:[String: AnyObject] = ["uId": uId, "flaggedUserId": flaggedUserId, "flagComplaint": flagComplaint]
        
        let ref = FIRDatabase.database().reference().child("flags")
        let childRef = ref.childByAutoId()
        childRef.updateChildValues(values) { (error, ref) in
            if (error != nil) {
                print("Error: ", error)
                return
            }
            print("Flag Saved!!")
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func setUpView() {
        view.addSubview(profileImageView)
        view.addSubview(instructionLabel)
        view.addSubview(nameLabel)
        view.addSubview(complaintTextView)
        
        complaintTextView.topAnchor.constraintEqualToAnchor(instructionLabel.bottomAnchor, constant: 20).active = true
        complaintTextView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        complaintTextView.heightAnchor.constraintEqualToConstant(200).active = true
        complaintTextView.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        
        nameLabel.topAnchor.constraintEqualToAnchor(profileImageView.bottomAnchor, constant: 10).active = true
        nameLabel.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        nameLabel.widthAnchor.constraintEqualToAnchor(view.widthAnchor, constant: -20).active = true
        nameLabel.heightAnchor.constraintEqualToConstant(50).active = true
        
        instructionLabel.topAnchor.constraintEqualToAnchor(nameLabel.bottomAnchor, constant: 10).active = true
        instructionLabel.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        instructionLabel.widthAnchor.constraintEqualToAnchor(view.widthAnchor, constant: -20).active = true
        instructionLabel.heightAnchor.constraintEqualToConstant(80).active = true
        
        
        profileImageView.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 90).active = true
        profileImageView.leftAnchor.constraintEqualToAnchor(view.leftAnchor, constant: 10).active = true
        profileImageView.widthAnchor.constraintEqualToConstant(150).active = true
        profileImageView.heightAnchor.constraintEqualToConstant(150).active = true
    }
    
    func handleDismiss() {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
