//
//  Post.swift
//  AppNormal
//
//  Created by Michelle Grover on 10/18/16.
//  Copyright © 2016 Norbert Grover. All rights reserved.
//

import UIKit

class Post: NSObject {
    var comment: String?
    var fromId: String?
    var postId: String?
    var timestamp: NSNumber?
    var postImageUrl: String?
    var videoUrl: String?
    
    init(dictionary: [String:AnyObject]) {
     super.init()
        
        comment = dictionary["comment"] as? String
        fromId = dictionary["fromId"] as? String
        postId = dictionary["postId"] as? String
        timestamp = dictionary["timestamp"] as? NSNumber
        postImageUrl = dictionary["postImageUrl"] as? String
        videoUrl = dictionary["videoUrl"] as? String
        
    }
}
