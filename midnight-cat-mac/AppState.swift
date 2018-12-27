//
//  AppState.swift
//  midnight-cat-mac
//
//  Created by Stephen Yao on 27/12/18.
//  Copyright © 2018 REA-Group. All rights reserved.
//

import Foundation
import Octokit

struct AppState {
  
  static var isSignedIn = false
  static var endpoint: String?
  static var clientID: String?
  static var accessToken: String?
  
  static var loginURL: URL? {
    guard
      let endpoint = endpoint,
      let clientID = clientID
      else {
        return nil
    }
    
    return URL(string: "https://\(endpoint)/login/oauth/authorize?scope=user&client_id=\(clientID)")
  }
  
  static var apiURL: URL? {
    guard let endpoint = endpoint else {
      return nil
    }
    
    return URL(string: "https://api.\(endpoint)")
  }
  
  static var octokitConfig: TokenConfiguration? {
    guard
      let apiURL = apiURL,
      let accessToken = accessToken
      else {
        return nil
    }
    
    return TokenConfiguration(accessToken, url: apiURL.absoluteString)
  }
}
