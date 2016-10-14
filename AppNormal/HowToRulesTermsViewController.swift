//
//  HowToRulesTermsViewController.swift
//  AppNormal
//
//  Created by Michelle Grover on 10/5/16.
//  Copyright © 2016 Norbert Grover. All rights reserved.
//

import UIKit

class HowToRulesTermsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = ChatMessageCell.orangeishColor
        view.backgroundColor = ChatMessageCell.browishColor
        navigationItem.title = "Terms of Use"
        
        setUpSegmentedControl()
    }
    
    func setUpSegmentedControl() {
        view.addSubview(ruleSegmentController)
        
        ruleSegmentController.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        ruleSegmentController.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 80).active = true
        ruleSegmentController.heightAnchor.constraintEqualToConstant(30).active = true
        ruleSegmentController.widthAnchor.constraintEqualToAnchor(view.widthAnchor, constant: -20).active = true
        
    }

    lazy var ruleSegmentController: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Rules","Termes of Service"])
        control.translatesAutoresizingMaskIntoConstraints = false
        control.selectedSegmentIndex = 0
        control.tintColor = ChatMessageCell.orangeishColor
        control.addTarget(self, action: #selector(handleSelectionChanged), forControlEvents: .ValueChanged)
        
        return control
    }()
    
    func handleSelectionChanged() {
    
    }

}
