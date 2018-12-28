//
//  RepositoriesSelectCoordinator.swift
//  midnight-cat-mac
//
//  Created by Stephen Yao on 28/12/18.
//  Copyright © 2018 REA-Group. All rights reserved.
//

import Foundation
import Octokit

final class RepositoriesSelectCoordinator {
  
  func load(from window: NSWindow) {
    guard let config = AppState.sharedInstance.octokitConfig else {
      return
    }
    
    let octokit = Octokit(config)
    
    let _ = octokit.repositories { (response) in
      switch response {
      case .success(let repositories):
        DispatchQueue.main.async {
          let viewController = RepositoriesSelectViewController.init(nibName: nil, bundle: nil)
          viewController.viewModel = RepositoriesSelectViewModel(ownedRepositories: repositories, starredRepositories: [])        
          window.contentViewController = viewController
        }
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
  }
  
}
