//
//  FlagContentController.swift
//  AppNormal
//
//  Created by Michelle Grover on 11/13/16.
//  Copyright © 2016 Norbert Grover. All rights reserved.
//

import UIKit
import Firebase

class FlagContentViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavbar()
    }
    
    func setupNavbar() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: #selector(closeController))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.blackColor()
       
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: #selector(saveFlaggedComment))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.blackColor()
        
        navigationController?.navigationBar.barTintColor = ChatMessageCell.orangeishColor
        if let font = UIFont(name: "Avenir-Heavy", size: 20) {
            navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: font]
        }
        view.backgroundColor = UIColor.whiteColor()
    }
    
    func saveFlaggedComment() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func closeController() {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
