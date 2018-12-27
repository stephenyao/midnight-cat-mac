//
//  OauthApplicationDetailsViewController.swift
//  midnight-cat-mac
//
//  Created by Stephen Yao on 26/12/18.
//  Copyright © 2018 REA-Group. All rights reserved.
//

import Cocoa

class OauthApplicationDetailsViewController: NSViewController {
  @IBOutlet var urlTextField: NSTextField!
  @IBOutlet var clientIDTextField: NSTextField!
  @IBOutlet var signInButton: NSButton!
  
  @IBAction func onSignInTapped(_ sender: Any) {
    guard
      let url = URL(string: urlTextField.stringValue),
      case let clientID = clientIDTextField.stringValue
    else {
      return
    }
  
    self.signInButton.isEnabled = false
    
    AppState.sharedInstance.endpoint = url.absoluteString
    AppState.sharedInstance.clientID = clientID
    
    if let loginURL = AppState.sharedInstance.loginURL {
      NSWorkspace.shared.open(loginURL)
    }    
  }
}
