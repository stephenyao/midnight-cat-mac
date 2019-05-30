//
//  SynchronisationService.swift
//  midnight-cat-mac
//
//  Created by Stephen Yao on 28/5/19.
//  Copyright © 2019 REA-Group. All rights reserved.
//

import Octokit

class SynchronisationService {
  
  private let dataStore: DataStore
  
  init(dataStore: DataStore = Database.sharedInstance) {
    self.dataStore = dataStore
  }
  
  func syncRepositories() {
    guard let config = AppState.sharedInstance.octokitConfig else {
      return
    }
    
    let repositories: [GitRepository] = self.dataStore.objects(with: DatabaseCollectionNames.repository)
    
    for repository in repositories {
      let _ = Octokit(config).pullRequests(owner: repository.owner!, repository: repository.name) { response in
        switch response {
        case .success(let pullRequests):
          let pullRequests = pullRequests.compactMap { GitPullRequest(octoKitPullRequest: $0, repositoryID: repository.id) }
          pullRequests.forEach(self.dataStore.save)
        case .failure(let error):
          print("synchronisation error: \(error.localizedDescription)")
        }
      }
    }
  }
}
