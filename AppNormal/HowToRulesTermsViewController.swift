//
//  HowToRulesTermsViewController.swift
//  AppNormal
//
//  Created by Michelle Grover on 10/5/16.
//  Copyright © 2016 Norbert Grover. All rights reserved.
//

import UIKit
import Firebase

class HowToRulesTermsViewController: UIViewController {
    
    let user = User()
    
    
    lazy var ruleSegmentController: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Rules","Terms of Service"])
        control.translatesAutoresizingMaskIntoConstraints = false
        control.selectedSegmentIndex = 0
        control.tintColor = ChatMessageCell.orangeishColor
        control.addTarget(self, action: #selector(handleSelectionChanged), forControlEvents: .ValueChanged)
        
        return control
    }()
    
    lazy var adminButton:UIButton = {
        let button = UIButton(type: .System)
        button.hidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = ChatMessageCell.orangeishColor
        button.layer.cornerRadius = 30
        button.layer.masksToBounds = true
        button.layer.borderWidth = 2
        button.layer.borderColor = ChatMessageCell.lightBrownishColor.CGColor
        button.setTitle("Admin", forState: .Normal)
        button.tintColor = UIColor.blackColor() 
        button.addTarget(self, action: #selector(getFlaggedContent), forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }()
    
    lazy var reportUserButton: UIButton = {
        let button = UIButton(type: .System)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = ChatMessageCell.orangeishColor
        button.setTitle("Report User", forState: .Normal)
        button.tintColor = UIColor.blackColor()
        button.addTarget(self, action: #selector(retrieveUsers), forControlEvents: UIControlEvents.TouchUpInside)
        
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        return button
    }()
    
    lazy var userSettingsButton: UIButton = {
        let button = UIButton(type: .System)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = ChatMessageCell.orangeishColor
        button.setTitle("Settings", forState: .Normal)
        button.tintColor = UIColor.blackColor()
        button.addTarget(self, action: #selector(getSettings), forControlEvents: UIControlEvents.TouchUpInside)
        
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        return button
    }()
    
    let rulesView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let rulesWebV:UIWebView = {
        let view = UIWebView(frame: CGRectMake(0,0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))

        if let NSBundlePath = NSBundle.mainBundle().pathForResource("rules", ofType: "html") {
            view.loadRequest(NSURLRequest(URL: NSURL(fileURLWithPath: NSBundlePath)))
        }
        view.backgroundColor = ChatMessageCell.orangeishColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let termsView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let termsWebV:UIWebView = {
        let view = UIWebView(frame: CGRectMake(0,0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))
        if let NSBundlePath = NSBundle.mainBundle().pathForResource("terms", ofType: "html") {
            view.loadRequest(NSURLRequest(URL: NSURL(fileURLWithPath: NSBundlePath)))
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func getSettings() {
        let settingsViewController = SettingsViewController()
        navigationController?.pushViewController(settingsViewController, animated: true)
    }
    
    func retrieveUsers() {
        let flagUserViewController = FlagUserTableViewController()
        navigationController?.pushViewController(flagUserViewController, animated: true)
    }
    
    func getFlaggedContent() {
        let flaggedcontentAdmin = FlaggedContentAdminViewController()
        navigationController?.pushViewController(flaggedcontentAdmin, animated: true)
    }
    
    let contentContainerView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = UIColor.whiteColor()
        return view
    }()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        isUserAnAdmin()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = ChatMessageCell.orangeishColor
        view.backgroundColor = ChatMessageCell.browishColor
        navigationItem.title = "Terms of Use"
        
        rulesView.hidden = false
        termsView.hidden = true
        setUpSegmentedControl()
        setUpContainerView()
    }
    
    func isUserAnAdmin() {
        
        guard let uId = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        let ref = FIRDatabase.database().reference().child("users").child(uId)
        ref.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User()
                user.setValuesForKeysWithDictionary(dictionary)
                self.isAdminButtonVisible(user)
            }
            }, withCancelBlock: nil)
    }
    
    func isAdminButtonVisible(obj: User) {
        
        if (obj.email == "Sosagrover1987@gmail.com") {
            adminButton.hidden = false
           
        } else {
            adminButton.hidden = true
            
        }
    }
    
    func setUpContainerView() {
        view.addSubview(contentContainerView)
        view.addSubview(adminButton)
        view.addSubview(reportUserButton)
        view.addSubview(rulesView)
        view.addSubview(termsView)
        view.addSubview(userSettingsButton)
        rulesView.addSubview(rulesWebV)
        termsView.addSubview(termsWebV)
        
        userSettingsButton.rightAnchor.constraintEqualToAnchor(adminButton.leftAnchor, constant: -5).active = true
        userSettingsButton.topAnchor.constraintEqualToAnchor(adminButton.topAnchor).active = true
        userSettingsButton.widthAnchor.constraintEqualToConstant(100).active = true
        userSettingsButton.heightAnchor.constraintEqualToConstant(60).active = true
        
        termsView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        termsView.topAnchor.constraintEqualToAnchor(adminButton.bottomAnchor, constant: 10).active = true
        termsView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor, constant: -60).active = true
        termsView.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        
        rulesView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        rulesView.topAnchor.constraintEqualToAnchor(adminButton.bottomAnchor, constant: 10).active = true
        rulesView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor, constant: -60).active = true
        rulesView.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        
        reportUserButton.leftAnchor.constraintEqualToAnchor(adminButton.rightAnchor, constant: 5).active = true
        reportUserButton.topAnchor.constraintEqualToAnchor(adminButton.topAnchor).active = true
        reportUserButton.widthAnchor.constraintEqualToConstant(100).active = true
        reportUserButton.heightAnchor.constraintEqualToConstant(60).active = true
        
        adminButton.topAnchor.constraintEqualToAnchor(ruleSegmentController.bottomAnchor, constant: 20).active = true
        adminButton.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        adminButton.widthAnchor.constraintEqualToConstant(60).active = true
        adminButton.heightAnchor.constraintEqualToConstant(60).active = true
        
        contentContainerView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        contentContainerView.topAnchor.constraintEqualToAnchor(adminButton.bottomAnchor, constant: 20).active = true
        contentContainerView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor, constant: -65).active = true
        contentContainerView.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
    }
    
    func setUpSegmentedControl() {
        view.addSubview(ruleSegmentController)
        
        ruleSegmentController.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        ruleSegmentController.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 80).active = true
        ruleSegmentController.heightAnchor.constraintEqualToConstant(30).active = true
        ruleSegmentController.widthAnchor.constraintEqualToAnchor(view.widthAnchor, constant: -20).active = true
    }

    
    
    func handleSelectionChanged() {
        //print(ruleSegmentController.selectedSegmentIndex)
        if (ruleSegmentController.selectedSegmentIndex == 0) {
            rulesView.hidden = false
            termsView.hidden = true
        } else {
            rulesView.hidden = true
            termsView.hidden = false
        }
    }

}
