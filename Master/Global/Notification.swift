//
//  Notification.swift
//  Master
//
//  Created by Dalton Ng on 26/12/18.
//  Copyright © 2018 Dalton Prescott. All rights reserved.
//

import UIKit
import SwiftMessages

public func showNewSetTabOptions(sender: UIViewController) {
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    alert.view.tintColor = universalDarkTintColour
    alert.view.backgroundColor = newSetCardBackgroundColour
    
    alert.addAction(UIAlertAction(title: "New Study Set", style: .default , handler:{ (UIAlertAction)in
        // Transition New Set
        sender.performSegue(withIdentifier: "toNewSet", sender: sender)
    }))
    
    alert.addAction(UIAlertAction(title: "Create Folder", style: .default , handler:{ (UIAlertAction)in
        // Draft
        // Does nothing for now
    }))
    
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
        // Cancel
    }))
    
    sender.present(alert, animated: true, completion: {
        // Done
    })
}

public func ShowSwiftMessageLoginError(_ errorMessage: String) {
    // Ensure all other messages are hidden!
    SwiftMessages.hideAll()
    
    // Instantiate a message view from the provided card view layout. SwiftMessages searches for nib
    // files in the main bundle first, so you can easily copy them into your project and make changes.
    let view = MessageView.viewFromNib(layout: .cardView)
    
    // Theme message elements with the warning style.
    view.configureTheme(.error)
    
    // Add a drop shadow.
    view.configureDropShadow()
    
    // Set message title, body, and icon. Here, we're overriding the default warning
    // image with an emoji character.
    let iconText = ["😳", "😬", "🧐"].sm_random()!
    view.configureContent(title: "Error", body: errorMessage, iconText: iconText)
    
    // Increase the external margin around the card. In general, the effect of this setting
    // depends on how the given layout is constrained to the layout margins.
    view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    
    // Reduce the corner radius (applicable to layouts featuring rounded corners).
    (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
    
    view.button?.removeFromSuperview()
    //view.button?.setTitle("Delete", for: .normal)
    
    view.buttonTapHandler = { _ in SwiftMessages.hide() } // Delete Button is here!!
    
    var config = SwiftMessages.Config()
    
    // Slide up from the bottom.
    config.presentationStyle = .center
    
    // Display in a window at the specified window level: UIWindow.Level.statusBar
    // displays over the status bar while UIWindow.Level.normal displays under.
    config.presentationContext = .window(windowLevel: .statusBar)
    
    // Disable the default auto-hiding behavior.
    config.duration = .forever
    
    // Dim the background like a popover view. Hide when the background is tapped.
    config.dimMode = .gray(interactive: true)
    
    // Disable the interactive pan-to-hide gesture.
    config.interactiveHide = true
    
    // Specify a status bar style to if the message is displayed directly under the status bar.
    config.preferredStatusBarStyle = .lightContent
    
    // Specify one or more event listeners to respond to show and hide events.
    /*config.eventListeners.append() { event in
     if case .didHide = event { print("yep") }
     }*/
    
    
    SwiftMessages.show(config: config, view: view)
}

public func ShowSwiftMessageMissingEntry(DeleteAction: @escaping () -> Void) {
    // Ensure all other messages are hidden!
    SwiftMessages.hideAll()
    
    // Instantiate a message view from the provided card view layout. SwiftMessages searches for nib
    // files in the main bundle first, so you can easily copy them into your project and make changes.
    let view = MessageView.viewFromNib(layout: .cardView)
    
    // Theme message elements with the warning style.
    view.configureTheme(.warning)
    
    // Add a drop shadow.
    view.configureDropShadow()
    
    // Set message title, body, and icon. Here, we're overriding the default warning
    // image with an emoji character.
    let iconText = ["😳", "😬", "🧐"].sm_random()!
    view.configureContent(title: "Error", body: "Please fill up the blank", iconText: iconText)
    
    // Increase the external margin around the card. In general, the effect of this setting
    // depends on how the given layout is constrained to the layout margins.
    view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    
    // Reduce the corner radius (applicable to layouts featuring rounded corners).
    (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
    
    view.button?.setTitle("Delete", for: .normal)
    
    view.buttonTapHandler = { _ in
        SwiftMessages.hide()
        DeleteAction()
    } // Delete Button is here!!
    
    var config = SwiftMessages.Config()
    
    // Slide up from the bottom.
    config.presentationStyle = .bottom
    
    // Display in a window at the specified window level: UIWindow.Level.statusBar
    // displays over the status bar while UIWindow.Level.normal displays under.
    config.presentationContext = .window(windowLevel: .statusBar)
    
    // Disable the default auto-hiding behavior.
    config.duration = .forever
    
    // Dim the background like a popover view. Hide when the background is tapped.
    config.dimMode = .gray(interactive: true)
    
    // Disable the interactive pan-to-hide gesture.
    config.interactiveHide = true
    
    // Specify a status bar style to if the message is displayed directly under the status bar.
    config.preferredStatusBarStyle = .lightContent
    
    // Specify one or more event listeners to respond to show and hide events.
    /*config.eventListeners.append() { event in
     if case .didHide = event { print("yep") }
     }*/
    
    
    SwiftMessages.show(config: config, view: view)
}
