//
//  Flag.swift
//  AppNormal
//
//  Created by Michelle Grover on 11/15/16.
//  Copyright © 2016 Norbert Grover. All rights reserved.
//

import UIKit

class Flag: NSObject {
    
    var uId: String?
    var flaggedUserId: String?
    var flaggedPostId: String?
    var flagComplaint: String?
    
    init(dictionary: [String:AnyObject]) {
        super.init()
        
        uId = dictionary["uId"] as? String
        flaggedUserId = dictionary["flaggedUserId"] as? String
        flaggedPostId = dictionary["flaggedPostId"] as? String
        flagComplaint = dictionary["flagComplaint"] as? String
    }
}

