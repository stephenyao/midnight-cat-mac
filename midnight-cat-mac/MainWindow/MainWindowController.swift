//
//  MainWindow.swift
//  midnight-cat-mac
//
//  Created by Stephen Yao on 25/12/18.
//  Copyright © 2018 REA-Group. All rights reserved.
//

import Cocoa

private protocol MainWindowPresenterDelegate: class {
  
  func presentZeroState()
  
  func presentRepositories()
  
  func presentLoggedOut()
  
}

private final class MainWindowPresenter: DataStoreObserver {
  
  private let dataStore: DataStore
  
  weak var delegate: MainWindowPresenterDelegate? {
    didSet {
      let objects: [GitRepository] = self.dataStore.objects(with: "repositories")
      
      if !AppState.sharedInstance.isSignedIn {
        self.delegate?.presentLoggedOut()
      } else {
        if objects.count == 0 {
          self.delegate?.presentZeroState()
        } else {
          self.delegate?.presentRepositories()
        }
      }
    }
  }
  
  init(dataStore: DataStore = Database.sharedInstance) {
    self.dataStore = dataStore
    self.dataStore.add(observer: self)
    NotificationCenter.default.addObserver(self, selector: #selector(onSignInSuccess), name: AppNotifications.signInSuccess, object: nil)
  }
  
  deinit {
    self.dataStore.remove(observer: self)
    NotificationCenter.default.removeObserver(self)
  }
  
  var uniqueObserverKey: String {
    return "MainWindowDataObserver"
  }
  
  var collectionName: String {
    return "repositories"
  }
  
  func onCollectionChanged(objects: [Storable]) {
    if objects.count == 0 {
      self.delegate?.presentZeroState()
    } else {
      self.delegate?.presentRepositories()
    }
  }
  
  @objc private func onSignInSuccess() {
    let objects: [GitRepository] = self.dataStore.objects(with: "repositories")
    if objects.count == 0 {
      self.delegate?.presentZeroState()
    } else {
      self.delegate?.presentRepositories()
    }
  }
  
}

class MainWindowController: NSWindowController, MainWindowPresenterDelegate {
  
  private let presenter: MainWindowPresenter = MainWindowPresenter(dataStore: Database.sharedInstance)
  
  override func windowDidLoad() {
    super.windowDidLoad()
    self.presenter.delegate = self
  }
  
  private func presentLoggedInState() {
    presentZeroState()
  }
  
  fileprivate func presentRepositories() {
    let repositoryContentViewController = RepositoryContentViewController.init(nibName: nil, bundle: nil)
    self.window?.contentViewController = repositoryContentViewController
  }
  
  fileprivate func presentZeroState() {
    let zeroStateViewController = ZeroStateViewController.init(nibName: nil, bundle: nil)
    self.window?.contentViewController = zeroStateViewController
  }
  
  fileprivate func presentLoggedOut() {
    let loggedOutViewController = LoggedOutViewController.init(nibName: nil, bundle: nil)
    self.window?.contentViewController = loggedOutViewController
  }
  
}
