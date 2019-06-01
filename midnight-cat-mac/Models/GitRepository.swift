//
//  GitRepository.swift
//  midnight-cat-mac
//
//  Created by Stephen Yao on 9/1/19.
//  Copyright © 2019 REA-Group. All rights reserved.
//

import Foundation
import Octokit

struct GitRepository: Storable, Codable {
  var primaryKey: String {
    return self.name
  }
  
  let id: Int
  let name: String
  let owner: String?
  let cloneURL: String?
  
  var collectionName: String {
    return "repositories"
  }
  
  init?(repository: Repository) {
    self.id = repository.id
    self.name = repository.name ?? ""
    self.owner = repository.owner.login ?? ""
    self.cloneURL = repository.cloneURL
  }
}
