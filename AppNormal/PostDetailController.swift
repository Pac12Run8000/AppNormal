//
//  PostDetailController.swift
//  AppNormal
//
//  Created by Michelle Grover on 10/21/16.
//  Copyright © 2016 Norbert Grover. All rights reserved.
//

import UIKit

class PostDetailController: UIViewController {
    
    var post: Post? {
        didSet {
        
        }
    }
    
    let commentLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.whiteColor()
        commentLabel.text = post?.comment
        mainContainer()
        
        
    }

    func mainContainer() {
        
        view.addSubview(commentLabel)
        
        commentLabel.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        commentLabel.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
        commentLabel.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        commentLabel.heightAnchor.constraintEqualToConstant(60).active = true
    }
    

}
