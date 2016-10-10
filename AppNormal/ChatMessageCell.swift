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
        tv.font = UIFont.systemFontOfSize(18)
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(textView)
        
        textView.rightAnchor.constraintEqualToAnchor(self.rightAnchor).active = true
        textView.topAnchor.constraintEqualToAnchor(self.topAnchor).active = true
        textView.widthAnchor.constraintEqualToConstant(200).active = true
        textView.heightAnchor.constraintEqualToAnchor(self.heightAnchor).active = true
        
//        backgroundColor = UIColor(red: 0.73, green: 0.00, blue: 0.00, alpha: 1.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
