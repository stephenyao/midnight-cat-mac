//
//  AppDelegate.swift
//  midnight-cat-mac
//
//  Created by Stephen Yao on 15/12/18.
//  Copyright © 2018 REA-Group. All rights reserved.
//

import Cocoa
import CoreData

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
    
    let synchronisationService = SynchronisationService()
    synchronisationService.syncRepositories()
    self.synchronisationService = synchronisationService
  }

  func application(_ application: NSApplication, open urls: [URL]) {
    urls.forEach(self.router.route)
  }

  @IBAction func selectRepositories(_ sender: NSMenuItem) {
    let controller = SelectRepositoriesWindowController.sharedInstance
    controller.showWindow(self)
  }
  
  func applicationWillTerminate(_ notification: Notification) {
    self.saveContext()
  }

  // MARK: - Core Data Saving support
  
  func saveContext () {
    let context = CoreDataManagedObjectContext.sharedInstance.context
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }

}
