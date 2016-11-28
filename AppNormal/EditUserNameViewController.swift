//
//  EditUserNameViewController.swift
//  AppNormal
//
//  Created by Michelle Grover on 11/28/16.
//  Copyright © 2016 Norbert Grover. All rights reserved.
//

import UIKit
import Firebase

class EditUserNameViewController: UIViewController {
    

    var settingsController: SettingsViewController?
    
    var user: User? {
        didSet {
            
        }
    }
    
    let userDisplayLabel:UITextField = {
        let label = UITextField()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = ChatMessageCell.orangeishColor
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 4
        label.layer.borderColor = UIColor.whiteColor().CGColor
        label.layer.borderWidth = 3
        label.textAlignment = .Center
        return label
    }()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
       
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        
        setUpLayout()
        
        view.addSubview(userDisplayLabel)
        
        userDisplayLabel.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        userDisplayLabel.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 100).active = true
        userDisplayLabel.widthAnchor.constraintEqualToAnchor(view.widthAnchor, constant: -20).active = true
        userDisplayLabel.heightAnchor.constraintEqualToConstant(40).active = true

        
    }
    
    func setUpLayout() {
        view.backgroundColor = ChatMessageCell.browishColor
        
            }
    
    func setUpNavigationBar() {
        navigationController?.navigationBar.barTintColor = ChatMessageCell.orangeishColor
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(handleDismiss))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: #selector(handleSave))
        
    }
    
    func handleSave() {
        guard let uId = FIRAuth.auth()?.currentUser?.uid, name = userDisplayLabel.text, email = user?.email, profileImageUrl = user?.profileImageUrl else {
            return
        }
        
        let properties:[String:AnyObject] = ["email":email, "name":name, "profileImageUrl":profileImageUrl]
        
        let ref = FIRDatabase.database().reference()
        let userRef = ref.child("users").child(uId)
        userRef.updateChildValues(properties) { (error, refer) in
            if (error != nil) {
                print("Error: ",error)
                return
            }
            self.settingsController!.userNameLabel.text = self.userDisplayLabel.text
            print("Update was successful")
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }

    func handleDismiss() {
        dismissViewControllerAnimated(true, completion: nil)
    }

    

}
