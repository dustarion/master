//
//  InitialViewController.swift
//  Master
//
//  Created by Dalton Ng on 25/12/18.
//  Copyright © 2018 Dalton Prescott. All rights reserved.
//

import UIKit
import Firebase
import Hero

class InitialViewController: UIViewController {
    override func viewDidAppear(_ animated: Bool) {
        self.hero.isEnabled = true
        // Check if logged in or not.
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                let RootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
                RootVC.hero.modalAnimationType = .zoom
                self.hero.replaceViewController(with: RootVC)
            }
            else {
                let LoginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! ViewController
                LoginVC.hero.modalAnimationType = .zoom
                self.hero.replaceViewController(with: LoginVC)
            }
        }
    }
}
