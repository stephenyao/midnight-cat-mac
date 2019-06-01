//
//  MyRepositoriesWindowController.swift
//  midnight-cat-mac
//
//  Created by Stephen Yao on 1/6/19.
//  Copyright © 2019 REA-Group. All rights reserved.
//

import Cocoa
import Octokit

class SelectRepositoriesWindowController: NSWindowController {
  private static var _sharedInstance: SelectRepositoriesWindowController?
  
  static var sharedInstance: SelectRepositoriesWindowController {
    guard _sharedInstance == nil else {
      return _sharedInstance!
    }
    
    let storyboard = NSStoryboard.init(name: "Main", bundle: nil)
    let controller = storyboard.instantiateController(withIdentifier: "SelectRepositoriesWindowController") as! SelectRepositoriesWindowController
    
    SelectRepositoriesWindowController._sharedInstance = controller
    return controller
  }
  
  private let context = CoreDataManagedObjectContext.sharedInstance.context
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  override func windowDidLoad() {
    super.windowDidLoad()
    let viewController = SelectRepositoriesLoadingViewController.init()
    self.window?.contentViewController = viewController
    
    guard let config = AppState.sharedInstance.octokitConfig else {
      return
    }

    let octokit = Octokit(config)
    let _ = octokit.myStars() { (response) in
      switch response {
      case .success(let fetchedRepositories):
        do {
          fetchedRepositories.forEach(self.save)
          let batchDeleteRequest = NSBatchDeleteRequest.init(fetchRequest: RepositoryManagedObject.fetchRequest())
          try self.context.execute(batchDeleteRequest)
          try self.context.save()
        } catch (let error) {
          print(error.localizedDescription)
        }
        
        DispatchQueue.main.async {
          let viewController = SelectRepositoryViewController.init()
          self.window?.contentViewController = viewController
        }
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
  }
  
  private func save(repository: Repository) {
    let managedObject = NSEntityDescription.insertNewObject(forEntityName: String(describing: RepositoryManagedObject.self), into: self.context) as! RepositoryManagedObject
    managedObject.name = repository.name
  }
}
