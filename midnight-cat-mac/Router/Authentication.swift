//
//  Authentication.swift
//  midnight-cat-mac
//
//  Created by Stephen Yao on 27/12/18.
//  Copyright © 2018 REA-Group. All rights reserved.
//

import Foundation

final class AuthenticationRoutable: Routable {
  
  private var executedUrl: URL?
  
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
    
    AppState.accessToken = accessToken
  }
  
}

