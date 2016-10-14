//
//  ChatMessageCell.swift
//  AppNormal
//
//  Created by Michelle Grover on 10/10/16.
//  Copyright © 2016 Norbert Grover. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation

class ChatMessageCell: UICollectionViewCell {
    
    var chatLogController: ChatLogController?
    var message: Message?
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.hidesWhenStopped = true
//        aiv.startAnimating()
        return aiv
    }()
    
    static let redishColor = UIColor(red: 0.73, green: 0.00, blue: 0.00, alpha: 1.0)
    static let orangeishColor = UIColor(red: 1.00, green: 0.53, blue: 0.14, alpha: 1.0)
    static let browishColor = UIColor(red: 0.17, green: 0.05, blue: 0.00, alpha: 1.0)
    static let lightBrownishColor = UIColor(red: 0.41, green: 0.01, blue: 0.01, alpha: 1.0)
    static let blackishColor = UIColor(red: 0.05, green: 0.00, blue: 0.00, alpha: 1.0)
    
    lazy var playButton: UIButton = {
        let btn = UIButton(type: .System)
        btn.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "play_button")
        btn.tintColor = UIColor.whiteColor()
        btn.setImage(image, forState: .Normal)
        btn.addTarget(self, action: #selector(handlePlay), forControlEvents: .TouchUpInside)
        return btn
    }()
    
    let textView:UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.text = "sample text"
        tv.font = UIFont.systemFontOfSize(16)
        tv.backgroundColor = UIColor.clearColor()
        tv.textColor = UIColor.whiteColor()
        tv.editable = false
        return tv
        
    }()
    
    let bubbleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0.73, green: 0.00, blue: 0.00, alpha: 1.0)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 16
        view.layer.borderColor = UIColor(red: 1.00, green: 0.53, blue: 0.14, alpha: 1.0).CGColor
        view.layer.borderWidth = 2
        return view
    }()
    
    let profileImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "default")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 16
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        return imageView
    }()
    
    lazy var messageImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 16
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.userInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomTap)))
        //imageView.backgroundColor = UIColor.redColor()
        return imageView
    }()
    
    var playerLayer: AVPlayerLayer?
    var player: AVPlayer?
    
    func handlePlay() {
        if let videoUrlString = message?.videoUrl, url = NSURL(string: videoUrlString) {
            player = AVPlayer(URL: url)
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.frame = bubbleView.bounds
            bubbleView.layer.addSublayer(playerLayer!)
            activityIndicatorView.startAnimating()
            playButton.hidden = true
            player?.play()
        }
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        playerLayer?.removeFromSuperlayer()
        player?.pause()
        activityIndicatorView.stopAnimating()
    }
    
    func handleZoomTap(tapGesture: UITapGestureRecognizer) {
        
        if (message?.videoUrl != nil) {
            return
        }
        
        if let imageView = tapGesture.view as? UIImageView {
            self.chatLogController?.performZoomInForStartingImageView(imageView)
        }
        
    }
    
    
    var bubbleWidthAnchor:NSLayoutConstraint?
    var bubbleViewRightAnchor: NSLayoutConstraint?
    var bubbleViewLeftAnchor: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bubbleView)
        addSubview(textView)
        addSubview(profileImageView)
        
        bubbleView.addSubview(messageImageView)
        
        messageImageView.leftAnchor.constraintEqualToAnchor(bubbleView.leftAnchor).active = true
        messageImageView.topAnchor.constraintEqualToAnchor(bubbleView.topAnchor).active = true
        messageImageView.widthAnchor.constraintEqualToAnchor(bubbleView.widthAnchor).active = true
        messageImageView.heightAnchor.constraintEqualToAnchor(bubbleView.heightAnchor).active = true
        
        bubbleView.addSubview(playButton)
        
        playButton.centerXAnchor.constraintEqualToAnchor(bubbleView.centerXAnchor).active = true
        playButton.centerYAnchor.constraintEqualToAnchor(bubbleView.centerYAnchor).active = true
        playButton.widthAnchor.constraintEqualToConstant(50).active = true
        playButton.heightAnchor.constraintEqualToConstant(50).active = true
        
        bubbleView.addSubview(activityIndicatorView)
        
        activityIndicatorView.centerXAnchor.constraintEqualToAnchor(bubbleView.centerXAnchor).active = true
        activityIndicatorView.centerYAnchor.constraintEqualToAnchor(bubbleView.centerYAnchor).active = true
        activityIndicatorView.widthAnchor.constraintEqualToConstant(50).active = true
        activityIndicatorView.heightAnchor.constraintEqualToConstant(50).active = true
        
        
        profileImageView.leftAnchor.constraintEqualToAnchor(self.leftAnchor, constant: 8).active = true
        profileImageView.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor).active = true
        profileImageView.widthAnchor.constraintEqualToConstant(32).active = true
        profileImageView.heightAnchor.constraintEqualToConstant(32).active = true
        
        
        
        
        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraintEqualToAnchor(profileImageView.rightAnchor, constant: 8)
        bubbleViewLeftAnchor?.active = false
        bubbleViewRightAnchor = bubbleView.rightAnchor.constraintEqualToAnchor(self.rightAnchor, constant: -10)
        bubbleViewRightAnchor?.active = true
        bubbleView.topAnchor.constraintEqualToAnchor(self.topAnchor).active = true
        bubbleWidthAnchor = bubbleView.widthAnchor.constraintEqualToConstant(200)
        bubbleWidthAnchor?.active = true
        bubbleView.heightAnchor.constraintEqualToAnchor(self.heightAnchor).active = true
        
        textView.leftAnchor.constraintEqualToAnchor(bubbleView.leftAnchor, constant: 8).active = true
        textView.topAnchor.constraintEqualToAnchor(self.topAnchor).active = true
        textView.rightAnchor.constraintEqualToAnchor(bubbleView.rightAnchor).active = true
        textView.heightAnchor.constraintEqualToAnchor(self.heightAnchor).active = true
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
