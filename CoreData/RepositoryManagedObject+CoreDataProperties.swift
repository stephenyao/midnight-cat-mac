//
//  RepositoryManagedObject+CoreDataProperties.swift
//  
//
//  Created by Stephen Yao on 31/5/19.
//
//

import Foundation
import CoreData


extension RepositoryManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RepositoryManagedObject> {
        return NSFetchRequest<RepositoryManagedObject>(entityName: "RepositoryManagedObject")
    }

    @NSManaged public var cloneURL: URL?
    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var owner: String?
    @NSManaged public var pullRequests: NSSet?

}

// MARK: Generated accessors for pullRequests
extension RepositoryManagedObject {

    @objc(addPullRequestsObject:)
    @NSManaged public func addToPullRequests(_ value: PullRequestManagedObject)

    @objc(removePullRequestsObject:)
    @NSManaged public func removeFromPullRequests(_ value: PullRequestManagedObject)

    @objc(addPullRequests:)
    @NSManaged public func addToPullRequests(_ values: NSSet)

    @objc(removePullRequests:)
    @NSManaged public func removeFromPullRequests(_ values: NSSet)

}
