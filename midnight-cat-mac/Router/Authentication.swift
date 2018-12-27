//
//  Authentication.swift
//  midnight-cat-mac
//
//  Created by Stephen Yao on 27/12/18.
//  Copyright © 2018 REA-Group. All rights reserved.
//

import Foundation

protocol AccessTokenStorage {
  
  var accessToken: String? { get }
  
  func store(accessToken: String)
  
}

final class AuthenticationRoutable: Routable {
  
  private var executedUrl: URL?
  private var accessTokenStorage: AccessTokenStorage
  
  init(accessTokenStorage: AccessTokenStorage) {
    self.accessTokenStorage = accessTokenStorage
  }
  
  var url: URL {
    return URL(string: "midnight-cat://authorised")!
  }
  
  func executeRoute(from url: URL) {
    let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
    guard
      let queryItem = components?.queryItems?.first(where: { $0.name == "access_token" }),
      let accessToken = queryItem.value
      else {
        return
    }
    
    self.accessTokenStorage.store(accessToken: accessToken)
    
    NotificationCenter.default.post(name: AppNotifications.signInSuccess, object: nil)
  }
  
}

