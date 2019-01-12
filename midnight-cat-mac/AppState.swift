//
//  AppState.swift
//  midnight-cat-mac
//
//  Created by Stephen Yao on 27/12/18.
//  Copyright © 2018 REA-Group. All rights reserved.
//

import Foundation
import Octokit

protocol UserAuthenticationState {
  
  var isSignedIn: Bool { get }
  
}

final class AppState: UserAuthenticationState, AccessTokenStorage {
  
  static var sharedInstance = AppState()
  
  var endpoint: String? {
    get {
      return UserDefaults.standard.string(forKey: "endpoint")
    }
    set {
      UserDefaults.standard.setValue(newValue, forKey: "endpoint")
      UserDefaults.standard.synchronize()
    }
  }
  
  var clientID: String? {
    get {
      return UserDefaults.standard.string(forKey: "clientID")
    }
    set {
      UserDefaults.standard.setValue(newValue, forKey: "clientID")
      UserDefaults.standard.synchronize()
    }
  }
  
  var accessToken: String? {
    get {
      return UserDefaults.standard.string(forKey: "accessToken")
    }
    set {
      UserDefaults.standard.setValue(newValue, forKey: "accessToken")
      UserDefaults.standard.synchronize()
    }
  }
  
  var isSignedIn: Bool {
    return self.accessToken != nil
  }
  
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
