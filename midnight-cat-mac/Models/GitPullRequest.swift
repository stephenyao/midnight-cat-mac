//
//  GitPullRequest.swift
//  midnight-cat-mac
//
//  Created by Stephen Yao on 28/5/19.
//  Copyright © 2019 REA-Group. All rights reserved.
//

import Foundation

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
}
