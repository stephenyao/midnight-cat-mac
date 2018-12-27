//
//  Router.swift
//  midnight-cat-mac
//
//  Created by Stephen Yao on 27/12/18.
//  Copyright © 2018 REA-Group. All rights reserved.
//

import Foundation

protocol Routable {
  
  var url: URL { get }
  
  func executeRoute()
  
}

final class Router {
  
  private let routables: [Routable]
  
  init(routables: [Routable]) {
    self.routables = routables
  }
  
  func route(url: URL) {
    routables.first { routable in
      let routableURL = routable.url
      
      let routableComponents = URLComponents(url: routableURL, resolvingAgainstBaseURL: true)
      let incomingURLComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
      
      return
        routableComponents?.host == incomingURLComponents?.host &&
          routableComponents?.path == incomingURLComponents?.path
      }?.executeRoute()
  }
  
}
