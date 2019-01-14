//
//  ProfileViewController.swift
//  Master
//
//  Created by Dalton Ng on 26/12/18.
//  Copyright © 2018 Dalton Prescott. All rights reserved.
//

import UIKit
import Firebase
import Hero

class ProfileViewController: UIViewController {
    
    // Profile Image
    @IBOutlet weak var profileImageView: UIImageView!
    
    // Display Name
    @IBOutlet weak var displayNameLabel: UILabel!
    
    @IBOutlet weak var earlyAdopterBadge: UIImageView!
    
    override func viewDidLoad() {
        displayNameLabel.text = getCurrentUserDisplayName()
        profileImageView.setRounded()
        setupProfilePhoto()
        
        checkForEarlyAdopterBadge(completion: { success in
            if success {
                self.setupEarlyAdopterBadge(true)
            } else {
                self.setupEarlyAdopterBadge(false)
            }
        })
    }
    
    func setupProfilePhoto() {
        let url = getCurrentUserProfilePhotoURL()
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            DispatchQueue.main.async() {
                self.profileImageView.image = UIImage(data: data)
            }
        }
    }
    
    func setupEarlyAdopterBadge(_ active: Bool) {
        if active {
            earlyAdopterBadge.isHidden = false
        } else {
            earlyAdopterBadge.isHidden = true
        }
    }
    
    @IBAction func giveFeedBackButton(_ sender: Any) {
        // Redirect to a feedback form
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        let alert = UIAlertController(title: "Do you want to logout?",
                                      message: "This action cannot be undone, you will have to log back in.",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler:{ action in
            print("Logging User Out")
            
            // Firebase Logout
            logout()
            
            // Transition To Login
            let LoginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! ViewController
            LoginVC.hero.modalAnimationType = .zoom
            self.hero.replaceViewController(with: LoginVC)
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    // Buy Early Adopter Badge
    @IBAction func buyCoffeeButton(_ sender: Any) {
        gainEarlyAdopterBadge()
        setupEarlyAdopterBadge(true)
    }
    
}
