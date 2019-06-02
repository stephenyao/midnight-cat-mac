//
//  MainWindow.swift
//  midnight-cat-mac
//
//  Created by Stephen Yao on 25/12/18.
//  Copyright © 2018 REA-Group. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController, MainWindowPresenterDelegate {
  
  private let presenter: MainWindowPresenter = MainWindowPresenter.init()
  
  override func windowDidLoad() {
    super.windowDidLoad()
    self.presenter.delegate = self
  }
  
  func presentRepositories() {
    let repositoryContentViewController = RepositoryContentViewController.init(nibName: nil, bundle: nil)
    self.window?.contentViewController = repositoryContentViewController
    self.window?.title = "Repositories"
  }
  
  func presentZeroState() {
    let zeroStateViewController = ZeroStateViewController.init(nibName: nil, bundle: nil)
    self.window?.contentViewController = zeroStateViewController
  }
  
  func presentLoggedOut() {
    let loggedOutViewController = LoginViewController.init(nibName: nil, bundle: nil)
    self.window?.contentViewController = loggedOutViewController
  }
  
}
