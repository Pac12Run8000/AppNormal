//
//  LoginController+handlers.swift
//  AppNormal
//
//  Created by Michelle Grover on 10/6/16.
//  Copyright © 2016 Norbert Grover. All rights reserved.
//

import UIKit
import Firebase

extension LoginController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func handleRegister() {
        guard let email = emailTextField.text, password = passwordTextField.text, name = nameTextField.text else {
            return
        }
        
        FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: { (user: FIRUser?, error) in
            if (error != nil) {
                print(error)
                return
            }
            
            guard let uid = user?.uid else {
                return
            }
            
           
            
            let storageRef = FIRStorage.storage().reference().child("myImage.png")
            
            if let uploadData = UIImagePNGRepresentation(self.profileImage.image!) {
                storageRef.putData(uploadData, metadata: nil, completion: { (metaData, error) in
                    if (error != nil) {
                        print("Upload Image ERROR:", error)
                        return
                    }
                    print(metaData)
                })
            }
            
            
            let ref = FIRDatabase.database().referenceFromURL("https://appnormal-e8c55.firebaseio.com/")
            let usersReference = ref.child("users").child(uid)
            let values = ["name": name, "email": email]
            usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                if (err != nil) {
                    print(err)
                    return
                }
                self.dismissViewControllerAnimated(true, completion: nil)
                print("Saved successfully")
            })
            
        })
    }
    
    func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        presentViewController(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        var selectedImageFromPicker:UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker {
            profileImage.image = selectedImage
        }
        
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
