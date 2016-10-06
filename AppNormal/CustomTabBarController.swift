//
//  CustomTabBarController.swift
//  AppNormal
//
//  Created by Michelle Grover on 10/4/16.
//  Copyright © 2016 Norbert Grover. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let MessageNavController = UINavigationController(rootViewController: ViewController())
//        let contactsBtn = UITabBarItem(tabBarSystemItem: .Contacts, tag: 0)
        MessageNavController.tabBarItem.title = "Message"
//      MessageNavController.tabBarItem.image = UIImage(named: .)
        
        
        let feedController = UINavigationController(rootViewController: FeedViewController())
//      let searchBtn = UITabBarItem(tabBarSystemItem: .Search, tag: 0)
        feedController.tabBarItem.title = "Feed"
//      feedController.tabBarItem.image = UIImage(named: .)
        
        let termsController = UINavigationController(rootViewController: HowToRulesTermsViewController())
        termsController.tabBarItem.title = "Rules and Terms"
        viewControllers = [MessageNavController, feedController, termsController]
    }
}
