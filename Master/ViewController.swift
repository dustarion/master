//
//  ViewController.swift
//  Master
//
//  Created by Dalton Ng on 24/12/18.
//  Copyright © 2018 Dalton Prescott. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit
import SwiftMessages

class ViewController: UIViewController, GIDSignInUIDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Login Notification Observer, listens from the App Delegate for successful Google Login
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(exitLogin),
                                               name: Notification.Name("ExitLoginViewController"),
                                               object: nil)
        
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    @objc func exitLogin() {
        // Go to Tab Bar Screens
        self.performSegue(withIdentifier: "loginToTab", sender: self)
//        let RootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RootViewController")
//        RootVC.hero.modalAnimationType = .zoom
//        self.hero.replaceViewController(with: RootVC)
    }
    
    // Sign in with Google
    @IBAction func GoogleSignIn(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    
    
    // Sign in with Facebook
    @IBAction func FacebookSignIn(_ sender: Any) {
        
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            
            guard let accessToken = FBSDKAccessToken.current() else {
                print("Failed to get access token")
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            // Perform login by calling Firebase APIs
            Auth.auth().signInAndRetrieveData(with: credential, completion: { (user, error) in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    ShowSwiftMessageLoginError(error.localizedDescription)
                    return
                }
                
                // Logged In!
                print("Successful Facebook Login")
                self.exitLogin()
                
            })
            
        }
    }
}

