//
//  midnight_cat_macTests.swift
//  midnight-cat-macTests
//
//  Created by Stephen Yao on 27/12/18.
//  Copyright © 2018 REA-Group. All rights reserved.
//

import XCTest
@testable import midnight_cat_mac

class AuthenticationRoutableTests: XCTestCase {
  
  func testValidRoute() {
    let store = MockAccessTokenStore()
    let routable = AuthenticationRoutable(accessTokenStorage: store)
    routable.executeRoute(from: URL(string: "midnight-cat://authorised?access_token=1234")!)
    
    XCTAssert(store.accessToken == "1234")
  }
  
  
  func testInvalidRoute() {
    let store = MockAccessTokenStore()
    let routable = AuthenticationRoutable(accessTokenStorage: store)
    routable.executeRoute(from: URL(string: "https://midnight-cat/authorised?foo_token=1234")!)
    
    XCTAssert(store.accessToken == nil)
  }
}

private class MockAccessTokenStore: AccessTokenStorage {
  
  var accessToken: String?
  
  func store(accessToken: String) {
    self.accessToken = accessToken
  }
  
}
