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
    
    func chatPartnerId() -> String? {
        return fromId == FIRAuth.auth()?.currentUser?.uid ? toId : fromId
        

        
    }

}
