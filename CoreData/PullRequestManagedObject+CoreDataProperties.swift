//
//  PullRequestManagedObject+CoreDataProperties.swift
//  
//
//  Created by Stephen Yao on 31/5/19.
//
//

import Foundation
import CoreData


extension PullRequestManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PullRequestManagedObject> {
        return NSFetchRequest<PullRequestManagedObject>(entityName: "PullRequestManagedObject")
    }

    @NSManaged public var author: String?
    @NSManaged public var createdAt: NSDate?
    @NSManaged public var number: Int16
    @NSManaged public var repositoryID: Int16
    @NSManaged public var title: String?
    @NSManaged public var url: URL?
    @NSManaged public var repository: RepositoryManagedObject?

}
