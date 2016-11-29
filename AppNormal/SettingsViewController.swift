//
//  SettingsViewController.swift
//  AppNormal
//
//  Created by Michelle Grover on 11/26/16.
//  Copyright © 2016 Norbert Grover. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    

    
    var user: User? {
        didSet {
            self.userNameLabel.text = user!.name
        }
    }
    
    
    
    lazy var deletButton:UIButton = {
        let button = UIButton(type: UIButtonType.System)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Delete Account", forState: UIControlState.Normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.backgroundColor = ChatMessageCell.redishColor
        button.tintColor = UIColor.blackColor()
        button.layer.borderColor = ChatMessageCell.orangeishColor.CGColor
        button.layer.borderWidth = 3
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDeleteUser)))
        return button
    }()
   
    
    lazy var userNameLabel:PaddingLabel = {
        let label = PaddingLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = ChatMessageCell.orangeishColor
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 5
        label.layer.borderColor = UIColor.whiteColor().CGColor
        label.layer.borderWidth = 2
        label.textAlignment = .Center
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(editUserName)))
        label.userInteractionEnabled = true
        return label
    }()
    
    let instructionLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = ChatMessageCell.redishColor
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        label.text = "click on the profileImage\n or username to edit\nLogout and log back in to see changes."
        label.textAlignment = .Center
        label.numberOfLines = 4
        return label
    }()
    
    
    lazy var profileImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "default")
        imageView.layer.borderColor = UIColor.whiteColor().CGColor
        imageView.layer.borderWidth = 2
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 50
        imageView.userInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleUpdateProfile)))
        return imageView
    }()
    
    func editUserName() {
        let editUserController = EditUserNameViewController()
        editUserController.settingsController = self
        editUserController.user = user
        let navigationController = UINavigationController(rootViewController: editUserController)
        presentViewController(navigationController, animated: true, completion: nil)
    }
    
    
    
    
    
    
    func handleDeleteUser() {

        let actionSheet: UIAlertController = UIAlertController(title: "Delete Account", message: "This will be a permanant action. Are you sure you want to do this?", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let deleteAlertAction:UIAlertAction = UIAlertAction(title: "Delete", style: .Destructive) { (alertAction:UIAlertAction) in

            guard let uId = FIRAuth.auth()?.currentUser?.uid else {
                return
            }
            
            //            Mark:Get all posts from the feed
            let ref = FIRDatabase.database().reference().child("feed")
            ref.observeEventType(.ChildAdded, withBlock: { (snapshot) in
                if let dictionary = snapshot.value as? [String:AnyObject] {
                    if (uId == dictionary["fromId"] as? String) {
                        
                        let postId = snapshot.key
                        let post = Post(dictionary: dictionary)
                        post.postId = postId
                            self.removePost(postId)
                    }
                    
                }
                }, withCancelBlock: nil)

            
//            Mark: Get all Flags
            let flagRef = FIRDatabase.database().reference().child("flags")
            flagRef.observeEventType(.ChildAdded, withBlock: { (snapshot) in
                if let dictionary = snapshot.value as? [String:AnyObject] {
                    if (uId == dictionary["flaggedUserId"] as? String || uId == dictionary["uId"] as? String) {
                        let flagId = snapshot.key
                        let flag = Flag(dictionary: dictionary)
                        flag.flagId = flagId
                        self.removeFlags(flag)
                    }
                }
                }, withCancelBlock: nil)
            
//            Mark: Get and delete all users
            let userRef = FIRDatabase.database().reference().child("users").child(uId)
            userRef.removeValueWithCompletionBlock({ (error, uRef) in
                if (error != nil) {
                    print(error)
                    return
                }
                print("User Deleted")
            })
            
//            Mark: Get all likes
            let likeRef = FIRDatabase.database().reference().child("likes")
            likeRef.observeEventType(.ChildAdded, withBlock: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    if (uId == dictionary["uId"] as? String) {
                        let likeId = snapshot.key
                        let like = Like(dictionary: dictionary)
                        like.likeId = likeId
                        self.removeLike(likeId)
                    }
                }
                }, withCancelBlock: nil)
            
            

            
//          Mark: sign out of app
            do {
                try FIRAuth.auth()?.signOut()
            } catch let logoutErr {
                print(logoutErr)
            }
            
            let customController = CustomTabBarController()
            self.presentViewController(customController, animated: true, completion: nil)

        }
        let cancelAction:UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { (alertAction:UIAlertAction) in
            print("Deletion Cancelled")
        }
        actionSheet.addAction(deleteAlertAction)
        actionSheet.addAction(cancelAction)
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    
    
    
    
    
    private func removeFlags(flag: Flag) {
//        print("FlagId:", flag.flagId)
        if let myFlagId = flag.flagId {
            let deletFlagRef = FIRDatabase.database().reference().child("flags").child(myFlagId)
            deletFlagRef.removeValueWithCompletionBlock({ (error, ref) in
                if (error != nil) {
                    print(error)
                    return
                }
//                print("Flag removed")
            })
        }
    }
    
    private func removeLike(likeId: String) {
        let removeLikeRef = FIRDatabase.database().reference().child("likes").child(likeId)
        removeLikeRef.removeValueWithCompletionBlock { (error, ref) in
            if (error != nil) {
                print(error)
                return
            }
//            print("like removed!!!")
        }
    }
    
    
    private func removePost(postId: String) {
        let refRemove = FIRDatabase.database().reference().child("feed").child(postId)
        refRemove.removeValueWithCompletionBlock { (err, ref) in
            if (err != nil) {
                print("err:", err)
                return
            }
            print("post removed!!")
        }
    }
    
    
    func handleUpdateProfile() {
        
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
            profileImageView.image = selectedImage
        }
        uploadImageToStorage()
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func uploadImageToStorage() {
        
        guard let name = user?.name, email = user?.email, uId = user?.id else {
            return
        }
        
        let imageName = NSUUID().UUIDString
        let storageRef = FIRStorage.storage().reference().child("profile_images").child("\(imageName).jpg")
        
        if let pImage = self.profileImageView.image, uploadData = UIImageJPEGRepresentation(pImage, 0.1) {
            storageRef.putData(uploadData, metadata: nil, completion: { (metaData, error) in
                if (error != nil) {
                    print("UploadImage error:", error)
                    return
                }
                if let profileImageUrl = metaData?.downloadURL()?.absoluteString {
                    let properties = ["name": name, "email": email, "profileImageUrl": profileImageUrl]
                    
                    self.registerIntoDatabase(properties, uId: uId)
                }
            })
        }
        
    }
    
    func registerIntoDatabase(properties: [String:AnyObject], uId:String) {
//        print("profileImageUrl:",properties["profileImageUrl"], "name:", properties["name"], "uId:", properties["id"])
        
       
        
        let ref = FIRDatabase.database().reference()
        let userRef = ref.child("users").child(uId)
        userRef.updateChildValues(properties) { (error, reference) in
            if (error != nil) {
                print(error)
                return
            }
            print("Image saved successfully")
        }
    }

    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser()
        navigationController?.navigationBar.barTintColor = ChatMessageCell.orangeishColor
        view.backgroundColor = ChatMessageCell.browishColor
        
        
        setUpConstraints()
       
    }
    
    func fetchUser() {
       
        if let uId = FIRAuth.auth()?.currentUser?.uid {
            
        let ref = FIRDatabase.database().reference().child("users").child(uId)
        ref.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
                let myUser = User()
                
                myUser.id = snapshot.key
                myUser.setValuesForKeysWithDictionary(dictionary)
                self.user = myUser
                if let profileImageUrl = myUser.profileImageUrl {
                    self.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
                }
                self.userNameLabel.text = myUser.name
                
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
