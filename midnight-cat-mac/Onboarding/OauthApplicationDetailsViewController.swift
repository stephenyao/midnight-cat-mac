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
  
  @IBAction func onSignInTapped(_ sender: Any) {
    guard
      let url = URL(string: urlTextField.stringValue),
      case let clientID = clientIDTextField.stringValue
    else {
      return
    }
  
    AppState.endpoint = url.absoluteString
    AppState.clientID = clientID
    
    NSWorkspace.shared.open(AppState.loginUrl)
  }
}
