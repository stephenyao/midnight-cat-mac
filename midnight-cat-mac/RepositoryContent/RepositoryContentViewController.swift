//
//  RepositoryContentViewController.swift
//  midnight-cat-mac
//
//  Created by Stephen Yao on 13/1/19.
//  Copyright © 2019 REA-Group. All rights reserved.
//

import Cocoa
import Octokit

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
    left.minimumThickness = 200
    left.maximumThickness = 200
    left.canCollapse = false
    
    let right = NSSplitViewItem(contentListWithViewController: RepositoryContentEmptyDetailViewController())
    
    self.addSplitViewItem(left)
    self.addSplitViewItem(right)
    
    self.rightSplitViewItem = right
    self.splitView.dividerStyle = .thin
  }
  
  func repositoryWasSelected(atIndex index: Int) {
    let repository = self.repositories[index]
    
    guard let config = AppState.sharedInstance.octokitConfig else {
      return
    }
  
    let _ = Octokit(config).pullRequests(owner: repository.owner!, repository: repository.name) { (response) in
      switch response {
      case .success(let pullRequests):
        DispatchQueue.main.async {
          self.removeSplitViewItem(self.rightSplitViewItem)
          let pullRequests = pullRequests.map { GitPullRequest(title: $0.title ?? "", url: $0.htmlURL) }
          let repositoryDetailViewModel = RepositoryDetailsViewModel(cloneURL: repository.cloneURL ?? "", pullRequests: pullRequests)
          let detailsViewController = RepositoryDetailsViewController(viewModel: repositoryDetailViewModel)
          let newRightSplitViewItem = NSSplitViewItem(contentListWithViewController: detailsViewController)
          self.addSplitViewItem(newRightSplitViewItem)
          self.rightSplitViewItem = newRightSplitViewItem
        }
      case .failure(let error):
        print(error)
      }
    }
  }
  
}
