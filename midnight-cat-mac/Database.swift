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
  
  var primaryKey: String { get }
  
}

protocol DataStore {
  
  func save<T: Storable & Codable>(object: T)
  
  func remove<T: Storable & Codable>(object: T)
  
  func objects<T: Storable & Codable>(with collectionName: String) -> [T]
  
  func object<T: Storable & Codable>(primaryKey: String, from collection: String) -> T?
  
}

final class Database: DataStore {
  
  let userDefaults: UserDefaults
  
  init(userDefaults: UserDefaults = UserDefaults.standard) {
    self.userDefaults = userDefaults
  }
  
  func save<T: Storable & Codable>(object: T) {
    let collection: [T] = objects(with: object.collectionName)
    let newCollection = collection + [object]
    self.encodeAndSave(objects: newCollection, collectionName: object.collectionName)
  }
  
  func remove<T: Storable & Codable>(object: T) {
    let collection: [T] = self.objects(with: object.collectionName)    
    let newCollection = collection.filter { $0.primaryKey != object.primaryKey }
    self.encodeAndSave(objects: newCollection, collectionName: object.collectionName)
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
  
  func object<T: Storable & Codable>(primaryKey: String, from collection: String) -> T? {
    return self.objects(with: collection).first { $0.primaryKey == primaryKey }
  }
  
  private func encodeAndSave<T: Storable & Codable>(objects: [T], collectionName: String) {
    do {
      let data = try PropertyListEncoder().encode(objects)
      self.userDefaults.setValue(data, forKey: collectionName)
    } catch (let error) {
      print("database save failed with: \(error.localizedDescription)")
    }
  }
  
}
