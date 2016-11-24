//
//  Like.swift
//  AppNormal
//
//  Created by Michelle Grover on 11/24/16.
//  Copyright © 2016 Norbert Grover. All rights reserved.
//

import UIKit

class Like: NSObject {
    
    var likeId: String?
    var like: Bool?
    var postId: String?
    var uId: String?
    
    init(dictionary: [String:AnyObject]) {
        super.init()
        
        likeId = dictionary["likeId"] as? String
        like = dictionary["like"] as? Bool
        postId = dictionary["postId"] as? String
        uId = dictionary["uId"] as? String
        
    }

}
