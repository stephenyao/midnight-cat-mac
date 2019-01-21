//
//  RepositoryContentViewController.swift
//  midnight-cat-mac
//
//  Created by Stephen Yao on 13/1/19.
//  Copyright © 2019 REA-Group. All rights reserved.
//

import Cocoa

class RepositoryContentViewController: NSSplitViewController {
  
  private let database: Database = Database()
  private var repositories: [GitRepository]  = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.repositories = self.database.objects(with: "repositories")
    
    let repositoryNames = self.repositories.map { $0.name }
    let viewModel = RepositoryListViewModel(repositoryNames: repositoryNames)
    let listViewController = RepositoryListViewController(viewModel: viewModel)
    
    let left = NSSplitViewItem(sidebarWithViewController: listViewController)
    let right = NSSplitViewItem(contentListWithViewController: RepositoryDetailsViewController.init(nibName: nil, bundle: nil))
    
    self.addSplitViewItem(left)
    self.addSplitViewItem(right)
  }
  
}
