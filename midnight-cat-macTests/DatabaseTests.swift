//
//  DatabaseTests.swift
//  midnight-cat-macTests
//
//  Created by Stephen Yao on 5/1/19.
//  Copyright © 2019 REA-Group. All rights reserved.
//

import XCTest
@testable import midnight_cat_mac

class DatabaseTests: XCTestCase {
  
  func testSavingObject() {
    let userDefaults = MockDefaults()
    let database = Database(userDefaults: userDefaults)
    let storable = MockStorable(identifier: "uniqueID")
    database.save(object: storable)
    
    guard let data = userDefaults.value(forKey: "MockCollection") as? Data else {
      XCTFail("no data available for key Mock")
      return
    }
    
    guard let objects = try? PropertyListDecoder().decode(Array<MockStorable>.self, from: data) else {
      XCTFail("failed to decode data to MockStorable Array")
      return
    }
    
    XCTAssert(objects.count == 1)
    XCTAssert(objects.first?.primaryKey == "uniqueID")
  }
  
  func testRemovingObject() {
    let userDefaults = MockDefaults()
    let database = Database(userDefaults: userDefaults)
    let mockObject = MockStorable(identifier: "1")
    let objects = [mockObject, MockStorable(identifier: "2")]
    let data = try! PropertyListEncoder().encode(objects)
    userDefaults.setValue(data, forKey: "MockCollection")
    
    database.remove(object: mockObject)
    
    guard let encodedData = userDefaults.value(forKey: "MockCollection") as? Data else {
      XCTFail("no data available for key Mock")
      return
    }
    
    guard let decodedObjects = try? PropertyListDecoder().decode(Array<MockStorable>.self, from: encodedData) else {
      XCTFail("failed to decode data to MockStorable Array")
      return
    }
    
    XCTAssert(decodedObjects.count == 1)
    XCTAssert(decodedObjects.first?.primaryKey == "2")
  }
  
  func testObjectRetrieval() {
    let userDefaults = MockDefaults()
    let objects = [MockStorable(identifier: "1"), MockStorable(identifier: "2")]
    let data = try! PropertyListEncoder().encode(objects)
    userDefaults.setValue(data, forKey: "MockCollection")

    let database = Database(userDefaults: userDefaults)
    let retrievedObjects: [MockStorable] = database.objects(with: "MockCollection")
    XCTAssert(retrievedObjects.count == 2)
    XCTAssert(retrievedObjects.first?.primaryKey == "1")
    XCTAssert(retrievedObjects.last?.primaryKey == "2")
  }
  
}

private final class MockDefaults: UserDefaults {
  var values: [String: Any] = [:]
  
  override func setValue(_ value: Any?, forKey key: String) {
    self.values[key] = value
  }
  
  override func value(forKey key: String) -> Any? {
    let value = self.values[key]
    return value
  }
}

private final class MockStorable: Storable, Codable {
  
  let primaryKey: String
  
  var collectionName: String {
    return "MockCollection"
  }
  
  init(identifier: String) {
    self.primaryKey = identifier
  }
  
}
