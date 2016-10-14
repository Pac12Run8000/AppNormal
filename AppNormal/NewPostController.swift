//
//  NewPostController.swift
//  AppNormal
//
//  Created by Michelle Grover on 10/14/16.
//  Copyright © 2016 Norbert Grover. All rights reserved.
//

import UIKit

class NewPostController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(handleCancel))
        navigationItem.leftBarButtonItem?.tintColor = ChatMessageCell.blackishColor
        navigationController?.navigationBar.barTintColor = ChatMessageCell.orangeishColor
       
    }
    func handleCancel() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    

}
