//
//  MainWindowPresenter.swift
//  midnight-cat-mac
//
//  Created by Stephen Yao on 13/1/19.
//  Copyright © 2019 REA-Group. All rights reserved.
//

import Foundation
import CoreData

protocol MainWindowPresenterDelegate: class {
  
  func presentZeroState()
  
  func presentRepositories()
  
  func presentLoggedOut()
  
}

final class MainWindowPresenter: NSObject, NSFetchedResultsControllerDelegate {
  
  private let authenticationState: UserAuthenticationState
  private let fetchResultsController: NSFetchedResultsController<RepositoryManagedObject>
  
  weak var delegate: MainWindowPresenterDelegate? {
    didSet {
      if !self.authenticationState.isSignedIn {
        self.delegate?.presentLoggedOut()
      } else {
        if self.fetchResultsController.fetchedObjects?.count == 0 {
          self.delegate?.presentZeroState()
        } else {
          self.delegate?.presentRepositories()
        }
      }
    }
  }
  
  init(authenticationState: UserAuthenticationState = AppState.sharedInstance,
       managedObjectContext: NSManagedObjectContext = CoreDataManagedObjectContext.sharedInstance.context) {
    self.authenticationState = authenticationState
    let fetchRequest: NSFetchRequest<RepositoryManagedObject> = RepositoryManagedObject.fetchRequest()
    fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "name", ascending: true)]
    let fetchResultsController = NSFetchedResultsController.init(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
    do { try fetchResultsController.performFetch() } catch {}
    self.fetchResultsController = fetchResultsController
    super.init()
    fetchResultsController.delegate = self
    NotificationCenter.default.addObserver(self, selector: #selector(onSignInSuccess), name: AppNotifications.signInSuccess, object: nil)
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  var uniqueObserverKey: String {
    return "MainWindowDataObserver"
  }
  
  var collectionName: String {
    return "repositories"
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    if controller.fetchedObjects?.count == 0 {
      self.delegate?.presentZeroState()
    } else {
      self.delegate?.presentRepositories()
    }
  }
  
  @objc private func onSignInSuccess() {
    if self.fetchResultsController.fetchedObjects?.count == 0 {
      self.delegate?.presentZeroState()
    } else {
      self.delegate?.presentRepositories()
    }
  }
  
}
