//
//  midnight_cat_macTests.swift
//  midnight-cat-macTests
//
//  Created by Stephen Yao on 27/12/18.
//  Copyright © 2018 REA-Group. All rights reserved.
//

import XCTest
@testable import midnight_cat_mac

class AppStateTests: XCTestCase {
  
  override func setUp() {
    AppState.endpoint = nil
    AppState.clientID = nil
    AppState.accessToken = nil
  }

  func testLoginURL() {
    AppState.endpoint = "test"
    AppState.clientID = "clientID"
    XCTAssert(AppState.loginURL?.absoluteString == "https://test/login/oauth/authorize?scope=user&client_id=clientID")
  }
  
  func testApiURL() {
    AppState.endpoint = "test"
    XCTAssert(AppState.apiURL?.absoluteString == "https://api.test")
  }
  
  func testOctokitConfig() {
    AppState.endpoint = "test"
    AppState.accessToken = "1234"
    XCTAssert(AppState.octokitConfig != nil)
  }

}
