//
//  RouterTests.swift
//  midnight-cat-macTests
//
//  Created by Stephen Yao on 27/12/18.
//  Copyright © 2018 REA-Group. All rights reserved.
//

import XCTest
@testable import midnight_cat_mac

class RouterTests: XCTestCase {
  
  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testRoutingWithBaseURL() {
    let mockRoutable = MockRoutable(urlString: "https://mock-routable")
    let router = Router(routables: [mockRoutable])
    
    router.route(url: URL(string: "https://mock-routable")!)
    
    XCTAssert(mockRoutable.executed == true)
  }
  
  func testRoutingWithSameURLPath() {
    let mockRoutable = MockRoutable(urlString: "https://mock-routable/test")
    let router = Router(routables: [mockRoutable])
    
    router.route(url: URL(string: "https://mock-routable/test")!)
    
    XCTAssert(mockRoutable.executed == true)
  }
  
  func testRoutingWithDifferentURLPath() {
    let mockRoutable = MockRoutable(urlString: "https://mock-routable/test1")
    let router = Router(routables: [mockRoutable])
    
    router.route(url: URL(string: "https://mock-routable/test2")!)
    
    XCTAssert(mockRoutable.executed == false)
  }
  
  func testRoutingWithQuery() {
    let mockRoutable = MockRoutable(urlString: "https://mock-routable/test?var=hello")
    let router = Router(routables: [mockRoutable])
    
    router.route(url: URL(string: "https://mock-routable/test")!)
    
    XCTAssert(mockRoutable.executed == true)
  }
  
}

private final class MockRoutable: Routable {
  
  var executed = false
  
  private var urlString: String
  
  init(urlString: String) {
    self.urlString = urlString
  }
  
  var url: URL {
    return URL(string: self.urlString)!
  }
  
  func executeRoute() {
    self.executed = true
  }
  
}
