//
//  NewPostController.swift
//  AppNormal
//
//  Created by Michelle Grover on 10/14/16.
//  Copyright © 2016 Norbert Grover. All rights reserved.
//

import UIKit
import Firebase
import MobileCoreServices
import AVFoundation

class NewPostController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let instructionLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Click box below to add photo."
        label.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 14)
        label.numberOfLines = 3
        label.textAlignment = .Center
        label.backgroundColor = ChatMessageCell.redishColor
        return label
    }()
    
    lazy var uploadImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .ScaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 8
        image.layer.borderWidth = 3
        image.layer.borderColor = ChatMessageCell.browishColor.CGColor
        image.userInteractionEnabled = true
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleUploadTap)))
        image.backgroundColor = ChatMessageCell.orangeishColor
        return image
        
    }()
    
    let descriptionTextField: UITextField = {
        let txtField = UITextField()
        txtField.placeholder = "Add message ..."
        txtField.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 18)
        txtField.translatesAutoresizingMaskIntoConstraints = false
        txtField.borderStyle = .RoundedRect
        txtField.layer.borderColor = ChatMessageCell.browishColor.CGColor
        
        return txtField
    }()
    
   

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(handleCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: #selector(handleSavePost))
        
        
        
        
        navigationItem.leftBarButtonItem?.tintColor = ChatMessageCell.blackishColor
        navigationItem.rightBarButtonItem?.tintColor = ChatMessageCell.blackishColor
        
        navigationController?.navigationBar.barTintColor = ChatMessageCell.orangeishColor
       
        view.backgroundColor = UIColor.whiteColor()
        
        setUpContainerView()

       setUpkeyboardObserver()
    }
    
    func setUpkeyboardObserver() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        
        let keyboardDuration = notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey]?.doubleValue
        
        descriptionTextFieldBottomAnchor?.constant = -10
        UIView.animateWithDuration(keyboardDuration!) {
            self.view.layoutIfNeeded()
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey]?.CGRectValue()
        let keyboardDuration = notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey]?.doubleValue
        
        descriptionTextFieldBottomAnchor?.constant = -10 + -keyboardFrame!.height
        UIView.animateWithDuration(keyboardDuration!) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    func handleSavePost() {
       
        
        let fromId = FIRAuth.auth()!.currentUser!.uid
        let timestamp: NSNumber = Int(NSDate().timeIntervalSince1970)
        guard let comment = self.descriptionTextField.text else {
            return
        }
        
        
        
        //image functionality
        let imageName = NSUUID().UUIDString
        let storageRef = FIRStorage.storage().reference().child("post_images").child(imageName)
        
        if let uploadData = UIImagePNGRepresentation(self.uploadImage.image!) {
            
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if (error != nil) {
                    print("Error:", error)
                    return
                }
                if let postImageUrl = metadata?.downloadURL()?.absoluteString {
                    let values:[String:AnyObject] = ["fromId": fromId, "timestamp": timestamp, "comment": comment, "postImageUrl":postImageUrl]
                    self.enterPostIntoDataBase(values)
                    
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            })

        }
        
    }
    
    private func enterPostIntoDataBase(values: [String:AnyObject]) {
        
        let ref = FIRDatabase.database().reference().child("feed")
        let childRef = ref.childByAutoId()
        childRef.updateChildValues(values) { (error, ref) in
            if (error != nil) {
                print(error)
                return
            }
            print("Data Saved successfully")
        }
    }
    
    
    func handleUploadTap() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        picker.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
        
        presentViewController(picker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let videoUrl = info[UIImagePickerControllerMediaURL] as? NSURL {
            
            handleVideoSelectedForUrl(videoUrl)
            
        } else {
        
           handleImageSelectedForInfo(info)
            
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func handleVideoSelectedForUrl(url: NSURL) {
        let timestamp:NSNumber = Int(NSDate().timeIntervalSince1970)
        guard let fromId = FIRAuth.auth()?.currentUser?.uid, comment = self.descriptionTextField.text else {
            return
        }
        
        let filename = "\(NSUUID().UUIDString).mov"
        let uploadTask = FIRStorage.storage().reference().child("post_videos").child(filename).putFile(url, metadata: nil, completion: { (metadata, error) in
            if (error != nil) {
                print("Failed Upload of Video:", error)
                return
            }
            
            if let videoUrl = metadata?.downloadURL()?.absoluteString {
                //print("videoUrl:", storageUrl)
                 let properties:[String:AnyObject] = ["fromId": fromId, "timestamp": timestamp, "comment": comment, "videoUrl":videoUrl]
                 self.sendVideoPostwithProperties(properties)
            }
        })
        
        uploadTask.observeStatus(.Progress) { (snapshot) in
            if let completedUnitCount = snapshot.progress?.completedUnitCount {
                self.navigationItem.title = String(completedUnitCount)
            }
            
        uploadTask.observeStatus(.Success, handler: { (snapshot) in
            self.navigationItem.title = "Video ready to be saved"
        })
           
        }
    }
    
    private func sendVideoPostwithProperties(properties: [String: AnyObject]) {
        let ref = FIRDatabase.database().reference().child("feed")
        let childRef = ref.childByAutoId()
        
        childRef.updateChildValues(properties) { (error, ref) in
            if (error != nil) {
                print("error:", error)
                return
            }
            print("Upload Successful!!!")
        }
        
        
//        let ref = FIRDatabase.database().reference().child("messages")
//        let childRef = ref.childByAutoId()
//        
//        let toId = user!.id!
//        let fromId = FIRAuth.auth()!.currentUser!.uid
//        let timestamp: NSNumber = Int(NSDate().timeIntervalSince1970)
//        var values: [String:AnyObject] = ["toId": toId, "fromId": fromId, "timestamp": timestamp]
//        
//        properties.forEach({values[$0] = $1})
//        
//        childRef.updateChildValues(values) { (error, ref) in
//            if (error != nil) {
//                print(error)
//                return
//            }
//            
//            self.inputTextField.text = nil
//            
//            let userMessagesRef = FIRDatabase.database().reference().child("user-messages").child(fromId).child(toId)
//            let messageId = childRef.key
//            userMessagesRef.updateChildValues([messageId: 1])
//            
//            let recipientUserMessagesRef = FIRDatabase.database().reference().child("user-messages").child(toId).child(fromId)
//            recipientUserMessagesRef.updateChildValues([messageId: 1])
//            
//        }
        
    }
    
    private func handleImageSelectedForInfo(info:[String: AnyObject]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker {
            uploadImage.image = selectedImage
        }
    }
    
    var descriptionTextFieldBottomAnchor: NSLayoutConstraint?
    
    
    func setUpContainerView() {
        view.addSubview(descriptionTextField)
        view.addSubview(uploadImage)
        view.addSubview(instructionLabel)
        
        
        
        instructionLabel.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        instructionLabel.bottomAnchor.constraintEqualToAnchor(uploadImage.topAnchor, constant: -10).active = true
        instructionLabel.widthAnchor.constraintEqualToAnchor(view.widthAnchor, constant: -10).active = true
        instructionLabel.heightAnchor.constraintEqualToConstant(50).active = true
        
        uploadImage.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        uploadImage.bottomAnchor.constraintEqualToAnchor(descriptionTextField.topAnchor, constant: -10).active = true
        uploadImage.widthAnchor.constraintEqualToConstant(100).active = true
        uploadImage.heightAnchor.constraintEqualToConstant(100).active = true
        
        descriptionTextField.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        
        descriptionTextFieldBottomAnchor = descriptionTextField.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor, constant: -10)
        descriptionTextFieldBottomAnchor?.active = true
        
        descriptionTextField.widthAnchor.constraintEqualToAnchor(view.widthAnchor, constant: -10).active = true
        descriptionTextField.heightAnchor.constraintEqualToConstant(50).active = true
        
    }
    
    func handleCancel() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    

}
