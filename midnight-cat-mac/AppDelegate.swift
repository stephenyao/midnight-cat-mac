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
  private weak var selectRepositoriesWindow: NSWindow?
  
  private var router: Router!
  private var synchronisationService: SynchronisationService!
  
  func applicationDidFinishLaunching(_ notification: Notification) {    
    let authenticationRoutable = AuthenticationRoutable(accessTokenStorage: AppState.sharedInstance)
    
    let router = Router(routables: [authenticationRoutable])
    self.router = router
    self.synchronisationService = SynchronisationService()
    self.synchronisationService.syncRepositories()
  }

  func application(_ application: NSApplication, open urls: [URL]) {
    urls.forEach(self.router.route)
    
  }

  @IBAction func selectRepositories(_ sender: NSMenuItem) {
    if let window = selectRepositoriesWindow {
      window.makeKeyAndOrderFront(nil)
      return
    }
    
    let nextCoordinator = RepositoriesSelectCoordinator()
    self.selectRepositoriesWindow = nextCoordinator.createAndLoad(from: nil)
  }
}
