//
//  ChatLogController.swift
//  AppNormal
//
//  Created by Michelle Grover on 10/7/16.
//  Copyright © 2016 Norbert Grover. All rights reserved.
//

import UIKit
import Firebase


class ChatLogController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout {
    let cellId = "cellId"
    
    var user: User? {
        didSet {
            navigationItem.title = user?.name
            observeMessages()
        }
    }
    
    var messages = [Message]()
    
    func observeMessages() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        
        let userMessagesRef = FIRDatabase.database().reference().child("user-messages").child(uid)
        userMessagesRef.observeEventType(.ChildAdded, withBlock: { (snapshot) in
            
            let messageId = snapshot.key
            let messagesRef = FIRDatabase.database().reference().child("messages").child(messageId)
            messagesRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                guard let dictionary = snapshot.value as? [String:AnyObject] else {
                    return
                }
                let message = Message()
                message.setValuesForKeysWithDictionary(dictionary)
                // Note this is where we will add search functionality
                if message.chatPartnerId() == self.user?.id {
                // if a certain criterion is met, we will append
                    self.messages.append(message)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.collectionView?.reloadData()
                    })
                }
                
                }, withCancelBlock: nil)
            
            
            }, withCancelBlock: nil)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        var height:CGFloat = 80
        
        if let text = messages[indexPath.item].text {
            height = estimatedFrameForText(text).height + 20
        }
        
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    private func estimatedFrameForText(text:String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.UsesFontLeading.union(.UsesLineFragmentOrigin)
        return NSString(string: text).boundingRectWithSize(size, options: options, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(18)], context: nil)
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellId, forIndexPath: indexPath) as! ChatMessageCell
        let message = messages[indexPath.row]
        cell.textView.text = message.text

        cell.bubbleWidthAnchor?.constant = estimatedFrameForText(message.text!).width + 32
        
        return cell
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 107, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 107, right: 0)
        collectionView?.backgroundColor = UIColor(red: 0.17, green: 0.05, blue: 0.00, alpha: 1.0)
        collectionView?.alwaysBounceVertical = true
        collectionView?.registerClass(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        setUpInputComponents()
       
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
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
        containerView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor,constant: -49).active = true
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
//        childRef.updateChildValues(values)
        childRef.updateChildValues(values) { (error, ref) in
            if (error != nil) {
                print(error)
                return
            }
            
            self.inputTextField.text = nil
            
            let userMessagesRef = FIRDatabase.database().reference().child("user-messages").child(fromId)
            let messageId = childRef.key
            userMessagesRef.updateChildValues([messageId: 1])
            
            let recipientUserMessagesRef = FIRDatabase.database().reference().child("user-messages").child(toId)
            recipientUserMessagesRef.updateChildValues([messageId: 1])
            
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        handleSend()
        return true
    }
   
    

    

}
