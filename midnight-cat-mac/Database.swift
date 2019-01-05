//
//  Database.swift
//  midnight-cat-mac
//
//  Created by Stephen Yao on 5/1/19.
//  Copyright © 2019 REA-Group. All rights reserved.
//

import Foundation

protocol Storable {
  
  var collectionName: String { get }
  
}

protocol DataStore {
  
  func save<T: Storable & Codable>(object: T)
  
}

final class Database: DataStore {
  
  let userDefaults: UserDefaults
  
  init(userDefaults: UserDefaults = UserDefaults.standard) {
    self.userDefaults = userDefaults
  }
  
  func save<T: Storable & Codable>(object: T) {
    let collection: [T] = objects(with: object.collectionName)
    let newCollection = collection + [object]
    do {
      let data = try PropertyListEncoder().encode(newCollection)
      self.userDefaults.setValue(data, forKey: object.collectionName)
    } catch (let error) {
      print("database save failed with: \(error.localizedDescription)")
    }
  }
  
  func objects<T: Storable & Codable>(with collectionName: String) -> [T] {
    guard let encodedObjects = self.userDefaults.value(forKey: collectionName) as? Data else {
      return []
    }
    
    guard let decodedObjects = try? PropertyListDecoder().decode(Array<T>.self, from: encodedObjects) else {
      return []
    }
    
    return decodedObjects
  }
  
}
