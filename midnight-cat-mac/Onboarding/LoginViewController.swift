//
//  LoggedOutViewController.swift
//  midnight-cat-mac
//
//  Created by Stephen Yao on 25/12/18.
//  Copyright © 2018 REA-Group. All rights reserved.
//

import Cocoa

class LoginViewController: NSViewController {
  
  @IBAction func onLoginTapped(_ sender: Any) {
    let applicationDetailsViewController = OauthApplicationDetailsViewController.init(nibName: nil, bundle: nil)
    let window = NSWindow.init(contentViewController: applicationDetailsViewController)
    window.makeKeyAndOrderFront(nil)
  }
  
}
