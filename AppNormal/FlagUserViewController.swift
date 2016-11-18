//
//  FlagUserViewController.swift
//  AppNormal
//
//  Created by Michelle Grover on 11/18/16.
//  Copyright © 2016 Norbert Grover. All rights reserved.
//

import UIKit
import Firebase

class FlagUserViewController: UIViewController {

    var user: User? {
        didSet {
            navigationItem.title = user?.name
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = ChatMessageCell.orangeishColor
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(handleDismiss))
    }
    
    func handleDismiss() {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
