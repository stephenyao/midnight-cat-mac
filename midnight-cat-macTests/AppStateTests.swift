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
    AppState.sharedInstance.endpoint = nil
    AppState.sharedInstance.clientID = nil
    AppState.sharedInstance.accessToken = nil
  }

  func testLoginURL() {
    AppState.sharedInstance.endpoint = "test"
    AppState.sharedInstance.clientID = "clientID"
    XCTAssert(AppState.sharedInstance.loginURL?.absoluteString == "https://test/login/oauth/authorize?scope=user&client_id=clientID")
  }
  
  func testApiURL() {
    AppState.sharedInstance.endpoint = "test"
    XCTAssert(AppState.sharedInstance.apiURL?.absoluteString == "https://api.test")
  }
  
  func testOctokitConfig() {
    AppState.sharedInstance.endpoint = "test"
    AppState.sharedInstance.accessToken = "1234"
    XCTAssert(AppState.sharedInstance.octokitConfig != nil)
  }

}
