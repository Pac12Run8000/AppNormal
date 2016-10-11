//
//  ChatMessageCell.swift
//  AppNormal
//
//  Created by Michelle Grover on 10/10/16.
//  Copyright © 2016 Norbert Grover. All rights reserved.
//

import UIKit
import Firebase

class ChatMessageCell: UICollectionViewCell {
    
    let textView:UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.text = "sample text"
        tv.font = UIFont.systemFontOfSize(16)
        tv.backgroundColor = UIColor.clearColor()
        tv.textColor = UIColor.whiteColor()
        return tv
        
    }()
    
    let bubbleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0.73, green: 0.00, blue: 0.00, alpha: 1.0)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 16
        view.layer.borderColor = UIColor.whiteColor().CGColor
        view.layer.borderWidth = 2
        return view
    }()
    
    var bubbleWidthAnchor:NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bubbleView)
        addSubview(textView)
        
        bubbleView.rightAnchor.constraintEqualToAnchor(self.rightAnchor, constant: -10).active = true
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
