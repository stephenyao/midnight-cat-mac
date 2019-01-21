//
//  RepositoryContentViewController.swift
//  midnight-cat-mac
//
//  Created by Stephen Yao on 13/1/19.
//  Copyright © 2019 REA-Group. All rights reserved.
//

import Cocoa

class RepositoryContentViewController: NSSplitViewController, RepositoryListViewControllerDelegate {
  
  private let database: Database = Database()
  private var repositories: [GitRepository]  = []
  private var rightSplitViewItem: NSSplitViewItem!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.repositories = self.database.objects(with: "repositories")
    
    let repositoryNames = self.repositories.map { $0.name }
    let viewModel = RepositoryListViewModel(repositoryNames: repositoryNames)
    let listViewController = RepositoryListViewController(viewModel: viewModel)
    listViewController.delegate = self
    
    let left = NSSplitViewItem(sidebarWithViewController: listViewController)
    let right = NSSplitViewItem(contentListWithViewController: RepositoryDetailsViewController(repository: nil))
    
    self.addSplitViewItem(left)
    self.addSplitViewItem(right)
    
    self.rightSplitViewItem = right
  }
  
  func repositoryWasSelected(atIndex index: Int) {
    let repository = self.repositories[index]
    let detailsViewController = RepositoryDetailsViewController(repository: repository)
    self.removeSplitViewItem(self.rightSplitViewItem)
    let newRightSplitViewItem = NSSplitViewItem(contentListWithViewController: detailsViewController)
    self.addSplitViewItem(newRightSplitViewItem)
    self.rightSplitViewItem = newRightSplitViewItem
  }
  
}
