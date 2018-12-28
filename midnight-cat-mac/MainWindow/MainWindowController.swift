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
      let zeroStateViewController = ZeroStateViewController.init(nibName: nil, bundle: nil)
      self.window?.contentViewController = zeroStateViewController
    } else {
      let loggedOutViewController = LoggedOutViewController.init(nibName: nil, bundle: nil)
      self.window?.contentViewController = loggedOutViewController
    }
  }
  
}
