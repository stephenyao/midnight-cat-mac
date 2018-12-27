//
//  AppDelegate.swift
//  midnight-cat-mac
//
//  Created by Stephen Yao on 15/12/18.
//  Copyright © 2018 REA-Group. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  
  @IBOutlet weak var window: NSWindow!
  
  private var router: Router!
  
  func applicationDidFinishLaunching(_ notification: Notification) {
    let authenticationRoutable = AuthenticationRoutable(accessTokenStorage: AppState.sharedInstance)
    
    let router = Router(routables: [authenticationRoutable])
    self.router = router
  }

  func application(_ application: NSApplication, open urls: [URL]) {
    
    urls.forEach(self.router.route)
    
  }

}
