//
//  MainWindowPresenterTests.swift
//  midnight-cat-macTests
//
//  Created by Stephen Yao on 13/1/19.
//  Copyright © 2019 REA-Group. All rights reserved.
//

import XCTest
@testable import midnight_cat_mac

final class MainWindowPresenterTests: XCTestCase {
  private var delegate: MockPresenterDelegate = MockPresenterDelegate()
  
  override func setUp() {
    self.delegate = MockPresenterDelegate()
  }

  func testWhenUserIsNotSignedIn() {
    let presenter = MainWindowPresenter(dataStore: MockDataStore(), authenticationState: MockAuthenticationState(authenticated: false))
    presenter.delegate = delegate
    XCTAssert(self.delegate.state == .loggedOut)
  }
  
  func testWhenUserIsSignedInAndNoObjectsAreInDatabase() {
    let presenter = MainWindowPresenter(dataStore: MockDataStore(), authenticationState: MockAuthenticationState(authenticated: true))
    presenter.delegate = delegate
    XCTAssert(self.delegate.state == .zeroState)
  }
  
  func testWhenUserIsSignedInAnObjectsAreInDatabase() {
    let presenter = MainWindowPresenter(dataStore: MockDataStore(numberOfObjects: 1), authenticationState: MockAuthenticationState(authenticated: true))
    presenter.delegate = delegate
    XCTAssert(self.delegate.state == .repositories)
  }
  
  func testWhenDatabaseNotifiesThereAreMoreThanOneObject() {
    let presenter = MainWindowPresenter(dataStore: MockDataStore(numberOfObjects: 0), authenticationState: MockAuthenticationState(authenticated: true))
    presenter.delegate = delegate
    XCTAssert(self.delegate.state == .zeroState)
    presenter.onCollectionChanged(objects: [GitRepository(name: "Test", owner: "test", cloneURL: "test")])
    XCTAssert(self.delegate.state == .repositories)
  }
  
  func testWhenDatabaseNotifiesThereAreZeroObjects() {
    let presenter = MainWindowPresenter(dataStore: MockDataStore(numberOfObjects: 1), authenticationState: MockAuthenticationState(authenticated: true))
    presenter.delegate = delegate
    XCTAssert(self.delegate.state == .repositories)
    presenter.onCollectionChanged(objects: [])
    XCTAssert(self.delegate.state == .zeroState)
  }
  
}

private final class MockPresenterDelegate: MainWindowPresenterDelegate {
  
  var state: State = .unknown
  
  enum State {
    case zeroState
    case repositories
    case loggedOut
    case unknown
  }
  
  func presentZeroState() {
    self.state = .zeroState
  }
  
  func presentRepositories() {
    self.state = .repositories
  }
  
  func presentLoggedOut() {
    self.state = .loggedOut
  }
  
}

private final class MockDataStore: DataStore {
  
  private let numberOfObjects: Int
  
  init(numberOfObjects: Int = 0) {
    self.numberOfObjects = numberOfObjects
  }
  
  func save<T>(object: T) where T : Decodable, T : Encodable, T : Storable {
    
  }
  
  func remove<T>(object: T) where T : Decodable, T : Encodable, T : Storable {
    
  }
  
  func objects<T>(with collectionName: String) -> [T] where T : Decodable, T : Encodable, T : Storable {
    return (0..<self.numberOfObjects).map { _ in GitRepository(name: NSUUID.init().uuidString, owner: "test", cloneURL: "test") } as! [T]
  }
  
  func object<T>(primaryKey: String, from collection: String) -> T? where T : Decodable, T : Encodable, T : Storable {
    return nil
  }
  
  func add(observer: DataStoreObserver) {
    
  }
  
  func remove(observer: DataStoreObserver) {
    
  }
  
  
}

private final class MockAuthenticationState: UserAuthenticationState {
  
  private let authenticated: Bool
  
  var isSignedIn: Bool {
    return self.authenticated
  }
  
  init(authenticated: Bool) {
    self.authenticated = authenticated
  }
  
}
