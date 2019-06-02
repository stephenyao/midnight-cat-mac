//
//  CoreDataEntityInstantiator.swift
//  midnight-cat-mac
//
//  Created by Stephen Yao on 2/6/19.
//  Copyright © 2019 REA-Group. All rights reserved.
//

import Foundation
import CoreData

extension NSEntityDescription {
  @discardableResult static func repositoryEntity(forRepository repository: GitRepository, withContext context: NSManagedObjectContext) -> RepositoryManagedObject {
    let entity = NSEntityDescription.insertNewObject(forEntityName: String(describing: RepositoryManagedObject.self), into: context) as! RepositoryManagedObject
    entity.name = repository.name
    entity.id = Int16(repository.id)
    entity.cloneURL = URL(string: repository.cloneURL!)
    entity.selected = true
    entity.owner = repository.owner
    return entity
  }
  
  @discardableResult static func pullRequestEntity(forPullRequest pullRequest: GitPullRequest, withContext context: NSManagedObjectContext) -> PullRequestManagedObject {
    let entity = NSEntityDescription.insertNewObject(forEntityName: String(describing: PullRequestManagedObject.self), into: context) as! PullRequestManagedObject
    entity.createdAt = NSDate(timeIntervalSinceReferenceDate: pullRequest.createdAt.timeIntervalSinceReferenceDate)
    entity.author = pullRequest.author
    entity.number = Int16(pullRequest.number)
    entity.title = pullRequest.title
    entity.url = pullRequest.url
    return entity
  }
}
