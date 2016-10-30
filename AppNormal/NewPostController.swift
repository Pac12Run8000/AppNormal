//
//  NewPostController.swift
//  AppNormal
//
//  Created by Michelle Grover on 10/14/16.
//  Copyright © 2016 Norbert Grover. All rights reserved.
//

import UIKit
import Firebase

class NewPostController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let instructionLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Click box below to add photo"
        label.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 18)
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
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleGetImage)))
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
    
    
    func handleGetImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        presentViewController(picker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
           selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker {
            uploadImage.image = selectedImage
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
    func setUpContainerView() {
        view.addSubview(descriptionTextField)
        view.addSubview(uploadImage)
        view.addSubview(instructionLabel)
        
        instructionLabel.leftAnchor.constraintEqualToAnchor(view.leftAnchor, constant: 10).active = true
        instructionLabel.bottomAnchor.constraintEqualToAnchor(uploadImage.topAnchor, constant: 10).active = true
        instructionLabel.widthAnchor.constraintEqualToAnchor(view.widthAnchor, constant: -10).active = true
        instructionLabel.heightAnchor.constraintEqualToConstant(50).active = true
        
        uploadImage.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        uploadImage.bottomAnchor.constraintEqualToAnchor(descriptionTextField.topAnchor, constant: -10).active = true
        uploadImage.heightAnchor.constraintEqualToConstant(275).active = true
        uploadImage.widthAnchor.constraintEqualToAnchor(view.widthAnchor, constant: -10).active = true
        
        
        descriptionTextField.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        descriptionTextField.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor, constant: -10).active = true
        descriptionTextField.widthAnchor.constraintEqualToAnchor(view.widthAnchor, constant: -10).active = true
        descriptionTextField.heightAnchor.constraintEqualToConstant(50).active = true
        
    }
    
    func handleCancel() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    

}
