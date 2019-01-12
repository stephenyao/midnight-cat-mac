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

protocol DataStoreObserver {
  
  typealias CollectionChanged = ([Storable]) -> Void
  
  var collectionName: String { get }
  
  var uniqueObserverKey: String { get }

  func onCollectionChanged(objects: [Storable])
  
}

protocol DataStore {
  
  func save<T: Storable & Codable>(object: T)
  
  func remove<T: Storable & Codable>(object: T)
  
  func objects<T: Storable & Codable>(with collectionName: String) -> [T]
  
  func object<T: Storable & Codable>(primaryKey: String, from collection: String) -> T?
  
  func add(observer: DataStoreObserver)
  
  func remove(observer: DataStoreObserver)
  
}

/* Synchronous datastore. Writing and Reading happens on main thread for simplicity.
 * The scope of this database is not expected to handle huge data sets
 * and always writes to user defaults.
 */

final class Database: DataStore {
  
  private var observers: [DataStoreObserver] = []
  
  let userDefaults: UserDefaults
  
  static var sharedInstance = Database()
  
  init(userDefaults: UserDefaults = UserDefaults.standard) {
    self.userDefaults = userDefaults
  }
  
  func save<T: Storable & Codable>(object: T) {
    let collection: [T] = objects(with: object.collectionName)
    let newCollection = collection + [object]
    self.encodeAndSave(objects: newCollection, collectionName: object.collectionName)
    self.observers.filter { $0.collectionName == object.collectionName }.forEach { $0.onCollectionChanged(objects: newCollection) }
  }
  
  func remove<T: Storable & Codable>(object: T) {
    let collection: [T] = self.objects(with: object.collectionName)    
    let newCollection = collection.filter { $0.primaryKey != object.primaryKey }
    self.encodeAndSave(objects: newCollection, collectionName: object.collectionName)
    self.observers.filter { $0.collectionName == object.collectionName }.forEach { $0.onCollectionChanged(objects: newCollection) }
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
  
  func add(observer: DataStoreObserver) {
    self.observers.append(observer)    
  }
  
  func remove(observer: DataStoreObserver) {
    if let index = self.observers.firstIndex(where: { $0.uniqueObserverKey == observer.uniqueObserverKey }) {
      self.observers.remove(at: index)
    }
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
