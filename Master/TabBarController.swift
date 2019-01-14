//
//  TabBarController.swift
//  Master
//
//  Created by Dalton Ng on 31/12/18.
//  Copyright © 2018 Dalton Prescott. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        // Setup the tab bar delegate
        self.delegate = self
    }
    
    // Show the action sheet for New Set Tab
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        print(viewController.title)
        if viewController.title == "NewSetTabViewController" {
            showNewSetTabOptions(sender: self)
            return false
        }
        return true
    }
}
