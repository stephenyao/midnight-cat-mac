//
//  CoreDataManagedObjectFetcher.swift
//  midnight-cat-mac
//
//  Created by Stephen Yao on 2/6/19.
//  Copyright © 2019 REA-Group. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManagedObjectFetcher {
  static let sharedInstance: CoreDataManagedObjectFetcher = CoreDataManagedObjectFetcher()
  
  func repositoryManagedObject(withID id: Int, managedObjectContext context: NSManagedObjectContext) -> RepositoryManagedObject? {
    do {
      let fetchRequest: NSFetchRequest<RepositoryManagedObject> = RepositoryManagedObject.fetchRequest()
      fetchRequest.predicate = NSPredicate(format: "id == %d", id)
      let results = try context.fetch(fetchRequest)
      return results.first
    } catch {
      return nil
    }
  }
}
