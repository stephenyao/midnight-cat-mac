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
  
  func load() {
    guard let config = AppState.sharedInstance.octokitConfig else {
      return
    }
    
    let octokit = Octokit(config)
    
    let _ = octokit.repositories { (response) in
      switch response {
      case .success(let repositories):
        repositories.forEach { print($0) }
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
  }
  
}
