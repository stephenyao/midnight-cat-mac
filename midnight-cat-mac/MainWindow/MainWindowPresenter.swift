//
//  MainWindowPresenter.swift
//  midnight-cat-mac
//
//  Created by Stephen Yao on 13/1/19.
//  Copyright © 2019 REA-Group. All rights reserved.
//

import Foundation

protocol MainWindowPresenterDelegate: class {
  
  func presentZeroState()
  
  func presentRepositories()
  
  func presentLoggedOut()
  
}

final class MainWindowPresenter: DataStoreObserver {
  
  private let dataStore: DataStore
  private let authenticationState: UserAuthenticationState
  
  weak var delegate: MainWindowPresenterDelegate? {
    didSet {

      let objects: [GitRepository] = self.dataStore.objects(with: "repositories")
      
      if !self.authenticationState.isSignedIn {
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
  
  init(dataStore: DataStore = Database.sharedInstance,
       authenticationState: UserAuthenticationState = AppState.sharedInstance) {
    self.authenticationState = authenticationState
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
