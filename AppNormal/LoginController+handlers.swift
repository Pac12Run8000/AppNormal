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
        
        if name.isEmpty {
            errorDisplayLabel.text = "Enter a username"
            return
        }
        
        if email.isEmpty {
            errorDisplayLabel.text = "Enter an email address"
            return
        }
        
        if password.isEmpty {
            errorDisplayLabel.text = "enter a password"
            return
        }
        self.activityLabel.hidden = false
        self.loginActivityView.startAnimating()
        
        
        FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: { (user: FIRUser?, error) in
            
            if (error != nil) {
                print(error)
                if let errorCode = error?.code {
                    var errorText:String?
                    switch (errorCode) {
                    case 17011:
                        errorText = "This user does not exist."
                        break
                    case 17008:
                        errorText = "Enter a valid email"
                        break
                    default:
                        errorText = "Login Unsuccessful ..."
                    }
                    self.errorDisplayLabel.text = errorText
                
                }
                self.activityLabel.hidden = true
                self.loginActivityView.stopAnimating()
                
                return
            }
            
            guard let uid = user?.uid else {
                
                self.activityLabel.hidden = true
                self.loginActivityView.stopAnimating()
                
                return
            }
            
           
            let imageName = NSUUID().UUIDString
            let storageRef = FIRStorage.storage().reference().child("profile_images").child("\(imageName).jpg")
            
            if let pImage = self.profileImage.image, uploadData = UIImageJPEGRepresentation(pImage, 0.1) {
            
                storageRef.putData(uploadData, metadata: nil, completion: { (metaData, error) in
                    if (error != nil) {
                        print("Upload Image ERROR:", error)
                        
                        self.activityLabel.hidden = true
                        self.loginActivityView.stopAnimating()
                        
                        return
                    }
                    if let profileImageUrl = metaData?.downloadURL()?.absoluteString {
                        let values = ["name": name, "email": email, "profileImageUrl": profileImageUrl]
                        self.registerUserIntoDatabaseWithUID(uid, values: values)
                    }
                    
                    
                })
            }
            
        })
    }
    
    private func registerUserIntoDatabaseWithUID(uid:String, values: [String: AnyObject]) {
        let ref = FIRDatabase.database().reference()
        let usersReference = ref.child("users").child(uid)
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if (err != nil) {
                print(err)
                
                self.activityLabel.hidden = true
                self.loginActivityView.stopAnimating()
                
                return
            }
            let user = User()
            user.setValuesForKeysWithDictionary(values)
            
            self.messagesController?.setupNavBarWithUser(user)
            self.dismissViewControllerAnimated(true, completion: nil)
            print("Saved successfully")
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
