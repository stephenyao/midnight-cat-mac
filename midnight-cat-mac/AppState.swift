//
//  AppState.swift
//  midnight-cat-mac
//
//  Created by Stephen Yao on 27/12/18.
//  Copyright © 2018 REA-Group. All rights reserved.
//

import Foundation
import Octokit

final class AppState: AccessTokenStorage {
  
  static var sharedInstance = AppState()
  
  var endpoint: String?
  var clientID: String?
  var accessToken: String?
  var isSignedIn = false
  
  var loginURL: URL? {
    guard
      let endpoint = endpoint,
      let clientID = clientID
      else {
        return nil
    }
    
    return URL(string: "https://\(endpoint)/login/oauth/authorize?scope=user&client_id=\(clientID)")
  }
  
  var apiURL: URL? {
    guard let endpoint = endpoint else {
      return nil
    }
    
    return URL(string: "https://api.\(endpoint)")
  }
  
  var octokitConfig: TokenConfiguration? {
    guard
      let apiURL = apiURL,
      let accessToken = accessToken
      else {
        return nil
    }
    
    return TokenConfiguration(accessToken, url: apiURL.absoluteString)
  }
  
  func store(accessToken: String) {
    self.accessToken = accessToken
  }
}
