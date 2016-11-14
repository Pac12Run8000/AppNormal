//
//  FlagContentController.swift
//  AppNormal
//
//  Created by Michelle Grover on 11/13/16.
//  Copyright © 2016 Norbert Grover. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation

class FlagContentViewController: UIViewController {
    
    var post: Post? {
        didSet {
        
        }
    }
    
    let profileImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.borderColor = ChatMessageCell.redishColor.CGColor
        imageView.layer.borderWidth = 3
        imageView.image = UIImage(named: "default")
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 30
        return imageView
    }()
    
    let nameLabel:ExtraPaddingLabel = {
        let label = ExtraPaddingLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        //label.backgroundColor = ChatMessageCell.orangeishColor
        label.textColor = UIColor.whiteColor()
        label.text = "default"
        return label
    }()
    
    let captionImage:UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .ScaleToFill
        imageView.image = UIImage(named: "default")
        imageView.backgroundColor = UIColor.lightGrayColor()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = ChatMessageCell.redishColor.CGColor
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavbar()
        setupViewLayout()
        fetchData()
    }
    
    var feedViewController: FeedViewController?
    
    func fetchData() {
        guard let uId = post?.fromId else {
            return
        }
        let ref = FIRDatabase.database().reference().child("users").child(uId)
        ref.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
                if let profileImageUrl = dictionary["profileImageUrl"] as? String {
                    self.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
                }
                if let profileName = dictionary["name"] as? String {
                    self.nameLabel.text = profileName
                }
            }
            }, withCancelBlock: nil)
        if let postImageUrl = post?.postImageUrl {
            self.captionImage.loadImageUsingCacheWithUrlString(postImageUrl)
        }
        
        if let videoUrl = post?.videoUrl, url = NSURL(string: videoUrl) {
            self.captionImage.image = generateThumnail(url, fromTime: Float64(1.22))
        }
    }
    
    func generateThumnail(url : NSURL, fromTime:Float64) -> UIImage? {
        let asset: AVAsset = AVAsset(URL: url)
        let assetImgGenerate: AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        assetImgGenerate.requestedTimeToleranceAfter = kCMTimeZero
        assetImgGenerate.requestedTimeToleranceBefore = kCMTimeZero
        
        do {
            let img: CGImageRef = try assetImgGenerate.copyCGImageAtTime(CMTimeMake(1, 60), actualTime: nil)
            let frameImg:UIImage = UIImage(CGImage: img)
            return frameImg
        } catch let err {
            print(err)
        }
        return nil
    }
    
    func setupViewLayout() {
        
        view.addSubview(nameLabel)
        view.addSubview(profileImageView)
        view.addSubview(captionImage)
        
        
        captionImage.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        captionImage.topAnchor.constraintEqualToAnchor(nameLabel.bottomAnchor, constant: 60).active = true
        captionImage.widthAnchor.constraintEqualToConstant(150).active = true
        captionImage.heightAnchor.constraintEqualToConstant(150).active = true
        
        
        nameLabel.leftAnchor.constraintEqualToAnchor(profileImageView.rightAnchor, constant: -10).active = true
        nameLabel.centerYAnchor.constraintEqualToAnchor(profileImageView.centerYAnchor).active = true
        nameLabel.rightAnchor.constraintEqualToAnchor(view.rightAnchor, constant: -10).active = true
        nameLabel.heightAnchor.constraintEqualToConstant(30).active = true
        
        profileImageView.leftAnchor.constraintEqualToAnchor(view.leftAnchor, constant: 10).active = true
        profileImageView.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 80).active = true
        profileImageView.widthAnchor.constraintEqualToConstant(60).active = true
        profileImageView.heightAnchor.constraintEqualToConstant(60).active = true
    }
    
    func setupNavbar() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: #selector(closeController))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.blackColor()
       
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: #selector(saveFlaggedComment))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.blackColor()
        
        navigationController?.navigationBar.barTintColor = ChatMessageCell.orangeishColor
        if let font = UIFont(name: "Avenir-Heavy", size: 20) {
            navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: font]
        }
        view.backgroundColor = ChatMessageCell.blackishColor    
    }
    
    func saveFlaggedComment() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func closeController() {
        dismissViewControllerAnimated(true, completion: nil)
    }

}

class ExtraPaddingLabel: UILabel {
    override func drawTextInRect(rect: CGRect) {
        super.drawTextInRect(CGRect(x: 20, y: 15, width: 300, height: 0))
    }
}


