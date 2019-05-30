//
//  GitPullRequest.swift
//  midnight-cat-mac
//
//  Created by Stephen Yao on 28/5/19.
//  Copyright © 2019 REA-Group. All rights reserved.
//

import Foundation
import Octokit

struct GitPullRequest: Storable, Codable {
  var collectionName: String {
    return DatabaseCollectionNames.repository
  }
  
  var primaryKey: String {
    return self.url.absoluteString
  }
  
  let title: String
  let url: URL!
  let createdAt: Date
  let author: String
  let number: Int
  let repositoryID: Int
  
  init?(octoKitPullRequest: PullRequest, repositoryID: Int) {
    guard
      let title = octoKitPullRequest.title,
      let url = octoKitPullRequest.htmlURL,
      let author = octoKitPullRequest.user?.login,
      let createdAt = octoKitPullRequest.createdAt,
      let number = octoKitPullRequest.number
    else {
      return nil
    }
    
    self.title = title
    self.url = url
    self.createdAt = createdAt
    self.author = author
    self.number = number
    self.repositoryID = repositoryID
  }
}
