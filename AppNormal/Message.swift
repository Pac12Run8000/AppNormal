//
//  Message.swift
//  AppNormal
//
//  Created by Michelle Grover on 10/7/16.
//  Copyright © 2016 Norbert Grover. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {
    
    var fromId:String?
    var text:String?
    var timestamp:NSNumber?
    var toId:String?
    var imageUrl: String?
    
    var imageWidth: NSNumber?
    var imageHeight: NSNumber?
    
    var videoUrl: String?
    
    func chatPartnerId() -> String? {
        return fromId == FIRAuth.auth()?.currentUser?.uid ? toId : fromId
        

        
    }
    
    init(dictionary: [String: AnyObject]) {
        super.init()
        
        fromId = dictionary["fromId"] as? String
        text = dictionary["text"] as? String
        timestamp = dictionary["timestamp"] as? NSNumber
        toId = dictionary["toId"] as? String
        imageUrl = dictionary["imageUrl"] as? String
        
        imageWidth = dictionary["imageWidth"] as? NSNumber
        imageHeight = dictionary["imageHeight"] as? NSNumber
        videoUrl = dictionary["videoUrl"] as? String
    }

}
