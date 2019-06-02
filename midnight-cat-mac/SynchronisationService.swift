//
//  SynchronisationService.swift
//  midnight-cat-mac
//
//  Created by Stephen Yao on 28/5/19.
//  Copyright © 2019 REA-Group. All rights reserved.
//

import Octokit
import CoreData

class SynchronisationService {
  private let managedObjectFetcher = CoreDataManagedObjectFetcher.sharedInstance
  private let managedObjectContext = CoreDataManagedObjectContext.sharedInstance.context
  
  func syncRepositories() {
    guard let config = AppState.sharedInstance.octokitConfig else {
      return
    }
    
    guard let repositories: [RepositoryManagedObject] = self.managedObjectFetcher.managedObjects(managedObjectContext: self.managedObjectContext) else {
      return
    }
    
    for repository in repositories {
      guard
        let owner = repository.owner,
        let name = repository.name
      else {
        continue
      }
      
      let _ = Octokit(config).pullRequests(owner: owner, repository: name) { response in
        switch response {
        case .success(let pullRequests):
          let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
//          context.perform {
//            pullRequests.forEach {
//              if let pullRequest = GitPullRequest(octoKitPullRequest: $0, repositoryID: Int(repository.id)) {
//                NSEntityDescription.pullRequestEntity(forPullRequest: pullRequest, withContext: context)
//              }
//            }
//            do {
//              try context.save()
//            } catch (let error) {
//              print(error.localizedDescription)
//            }
//          }
          
          DispatchQueue.main.async {
            print(pullRequests)
          }
        case .failure(let error):
          print(error)
        }
      }
    }
  }
}
