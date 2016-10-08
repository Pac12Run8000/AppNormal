//
//  ChatLogController.swift
//  AppNormal
//
//  Created by Michelle Grover on 10/7/16.
//  Copyright © 2016 Norbert Grover. All rights reserved.
//

import UIKit
import Firebase


class ChatLogController: UICollectionViewController, UITextFieldDelegate {
    
    var user: User? {
        didSet {
            navigationItem.title = user?.name
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor(red: 0.17, green: 0.05, blue: 0.00, alpha: 1.0)
        setUpInputComponents()
       
    }
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message ..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()


    func setUpInputComponents() {
        let containerView = UIView()
        containerView.backgroundColor = UIColor(red: 1.00, green: 0.53, blue: 0.14, alpha: 1.0)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        
        containerView.leftAnchor.constraintEqualToAnchor(view.leftAnchor).active = true
        containerView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor,constant: -50).active = true
        containerView.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        containerView.heightAnchor.constraintEqualToConstant(50).active = true
        
        let sendButton = UIButton(type: .System)
        sendButton.setTitle("Send", forState: .Normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.tintColor = UIColor.blackColor()
        sendButton.addTarget(self, action: #selector(handleSend), forControlEvents: .TouchUpInside)
        
        containerView.addSubview(sendButton)
        
        sendButton.rightAnchor.constraintEqualToAnchor(containerView.rightAnchor).active = true
        sendButton.centerYAnchor.constraintEqualToAnchor(containerView.centerYAnchor).active = true
        sendButton.widthAnchor.constraintEqualToConstant(80).active = true
        sendButton.heightAnchor.constraintEqualToAnchor(containerView.heightAnchor).active = true
        
        
        containerView.addSubview(inputTextField)
        
        inputTextField.leftAnchor.constraintEqualToAnchor(containerView.leftAnchor, constant: 10).active = true
        inputTextField.centerYAnchor.constraintEqualToAnchor(containerView.centerYAnchor).active = true
        inputTextField.rightAnchor.constraintEqualToAnchor(sendButton.leftAnchor).active = true
        inputTextField.heightAnchor.constraintEqualToAnchor(containerView.heightAnchor).active = true
        
        let seperatorLineView = UIView()
        seperatorLineView.translatesAutoresizingMaskIntoConstraints = false
        seperatorLineView.backgroundColor = UIColor.whiteColor()
        
        containerView.addSubview(seperatorLineView)
        seperatorLineView.leftAnchor.constraintEqualToAnchor(containerView.leftAnchor).active = true
        seperatorLineView.topAnchor.constraintEqualToAnchor(containerView.topAnchor).active = true
        seperatorLineView.widthAnchor.constraintEqualToAnchor(containerView.widthAnchor).active = true
        seperatorLineView.heightAnchor.constraintEqualToConstant(2).active = true
        
    }
    
    func handleSend() {
        let ref = FIRDatabase.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        
        let toId = user!.id!
        let fromId = FIRAuth.auth()!.currentUser!.uid
        let timestamp: NSNumber = Int(NSDate().timeIntervalSince1970)
        let values = ["text":inputTextField.text!, "toId": toId, "fromId": fromId, "timestamp": timestamp]
       childRef.updateChildValues(values)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        handleSend()
        return true
    }
   
    

    

}
