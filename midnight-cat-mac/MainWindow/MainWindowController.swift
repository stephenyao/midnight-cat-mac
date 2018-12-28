//
//  MainWindow.swift
//  midnight-cat-mac
//
//  Created by Stephen Yao on 25/12/18.
//  Copyright © 2018 REA-Group. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {
  
  override func windowDidLoad() {
    super.windowDidLoad()
    
    if AppState.sharedInstance.isSignedIn {
      presentZeroState()
    } else {
      presentLoggedOutState()
    }
    
    NotificationCenter.default.addObserver(self, selector: #selector(onSignInSuccess), name: AppNotifications.signInSuccess, object: nil)
  }
  
  @objc private func onSignInSuccess() {    
    presentZeroState()
  }
  
  private func presentZeroState() {
    let zeroStateViewController = ZeroStateViewController.init(nibName: nil, bundle: nil)
    self.window?.contentViewController = zeroStateViewController
  }
  
  private func presentLoggedOutState() {
    let loggedOutViewController = LoggedOutViewController.init(nibName: nil, bundle: nil)
    self.window?.contentViewController = loggedOutViewController
  }
  
}
