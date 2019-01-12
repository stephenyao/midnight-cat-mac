//
//  MainWindow.swift
//  midnight-cat-mac
//
//  Created by Stephen Yao on 25/12/18.
//  Copyright © 2018 REA-Group. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController, MainWindowPresenterDelegate {
  
  private let presenter: MainWindowPresenter = MainWindowPresenter(dataStore: Database.sharedInstance)
  
  override func windowDidLoad() {
    super.windowDidLoad()
    self.presenter.delegate = self
  }
  
  private func presentLoggedInState() {
    presentZeroState()
  }
  
  func presentRepositories() {
    let repositoryContentViewController = RepositoryContentViewController.init(nibName: nil, bundle: nil)
    self.window?.contentViewController = repositoryContentViewController
  }
  
  func presentZeroState() {
    let zeroStateViewController = ZeroStateViewController.init(nibName: nil, bundle: nil)
    self.window?.contentViewController = zeroStateViewController
  }
  
  func presentLoggedOut() {
    let loggedOutViewController = LoggedOutViewController.init(nibName: nil, bundle: nil)
    self.window?.contentViewController = loggedOutViewController
  }
  
}
