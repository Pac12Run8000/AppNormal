//
//  NewPostController.swift
//  AppNormal
//
//  Created by Michelle Grover on 10/14/16.
//  Copyright © 2016 Norbert Grover. All rights reserved.
//

import UIKit
import Firebase

class NewPostController: UIViewController {
    
    let instructionLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Click box below to add photo"
        return label
    }()
    
    lazy var uploadImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .ScaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 8
        image.layer.borderWidth = 3
        image.layer.borderColor = UIColor.whiteColor().CGColor
        image.userInteractionEnabled = true
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleGetImage)))
        return image
        
    }()
    
    let descriptionTextField: UITextField = {
        let txtField = UITextField()
        txtField.placeholder = "Add message ..."
        txtField.translatesAutoresizingMaskIntoConstraints = false
        txtField.borderStyle = .RoundedRect
        
        return txtField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(handleCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: #selector(handleSavePost))
        
        
        
        navigationItem.leftBarButtonItem?.tintColor = ChatMessageCell.blackishColor
        navigationItem.rightBarButtonItem?.tintColor = ChatMessageCell.blackishColor
        
        navigationController?.navigationBar.barTintColor = ChatMessageCell.orangeishColor
       
        view.backgroundColor = ChatMessageCell.redishColor
        
        setUpContainerView()

       
    }
    
    func handleSavePost() {
        let ref = FIRDatabase.database().reference().child("feed")
        let childRef = ref.childByAutoId()
        let fromId = FIRAuth.auth()!.currentUser!.uid
        let timestamp: NSNumber = Int(NSDate().timeIntervalSince1970)
        guard let comment = self.descriptionTextField.text else {
            return
        }
        let values:[String:AnyObject] = ["fromId": fromId, "timestamp": timestamp, "comment": comment]
        
        childRef.updateChildValues(values) { (error, ref) in
            if (error != nil) {
                print(error)
                return
            }
            print("Data Saved successfully")
            
        }
        
    }
    
    
    
    
    func handleGetImage() {
        print("Get Image")
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
        uploadImage.heightAnchor.constraintEqualToConstant(175).active = true
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
