//
//  GitRepository.swift
//  midnight-cat-mac
//
//  Created by Stephen Yao on 9/1/19.
//  Copyright © 2019 REA-Group. All rights reserved.
//

import Foundation

struct GitRepository: Storable, Codable {
  var primaryKey: String {
    return self.name
  }
  
  let name: String
  
  var collectionName: String {
    return "repositories"
  }
}
