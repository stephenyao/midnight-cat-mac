//
//  RepositoriesSelectCoordinator.swift
//  midnight-cat-mac
//
//  Created by Stephen Yao on 28/12/18.
//  Copyright © 2018 REA-Group. All rights reserved.
//

import Foundation
import Octokit

final class ContentContainerViewController: NSViewController {
  
  override func loadView() {
    self.view = NSView()
  }

}

final class RepositoriesSelectCoordinator {
  
  @discardableResult
  func createAndLoad(from window: NSWindow?) -> NSWindow? {
    guard let config = AppState.sharedInstance.octokitConfig else {
      return nil
    }
    
    let window = window ?? NSWindow.init(contentViewController: ContentContainerViewController())
    window.makeKeyAndOrderFront(nil)
    window.title = "Repositories"
    
    let octokit = Octokit(config)
    
    let _ = octokit.myStars() { (response) in
      switch response {
      case .success(let fetchedRepositories):
        let repositories = fetchedRepositories.map { GitRepository(id: $0.id, name: $0.name ?? "", owner: $0.owner.login, cloneURL: $0.cloneURL) }
        DispatchQueue.main.async {
          let viewController = RepositoriesSelectViewController(viewModel: RepositoriesSelectViewModel(repositories: repositories), database: Database.sharedInstance)
          window.contentViewController = viewController
        }
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
    
    return window
  }
  
}
