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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    NotificationCenter.default.addObserver(self, selector: #selector(onSignInSuccess), name: AppNotifications.signInSuccess, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(onSignInFailure), name: AppNotifications.signInFailed, object: nil)
  }
  
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
  
  @objc private func onSignInSuccess() {
    let nextCoordinator = RepositoriesSelectCoordinator()
    if let window = self.view.window {
      nextCoordinator.createAndLoad(from: window)
    }
  }
  
  @objc private func onSignInFailure() {
    self.signInButton.isEnabled = true
  }
}
