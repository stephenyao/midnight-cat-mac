//
//  AppDelegate.swift
//  midnight-cat-mac
//
//  Created by Stephen Yao on 15/12/18.
//  Copyright © 2018 REA-Group. All rights reserved.
//

import Cocoa
import Octokit

class AppState {
  static var isSignedIn = false
  static var endpoint: String!
  static var clientID: String!
  static var loginUrl: URL! {
    return URL(string: "\(endpoint!)/login/oauth/authorize?scope=user&client_id=\(clientID!)")
  }
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  
  @IBOutlet weak var window: NSWindow!

  func application(_ application: NSApplication, open urls: [URL]) {
    guard let url = urls.first else {
      return
    }
    
    let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
    guard
      let queryItem = components?.queryItems?.first(where: { $0.name == "access_token" }),
      let accessToken = queryItem.value
    else {
      return
    }
    
    let config = TokenConfiguration(accessToken, url: "https://api.git.realestate.com.au")
    Octokit(config).pullRequests(owner: "resi-mobile", repository: "resi-mobile-ios") { (response) in
      switch response {
      case .success(let pullRequest):
        print(pullRequest.first?.body)
      case .failure(let error):
        print(error)
      }
    }
    
    print("access token retrieved: \(accessToken)")
  }

}

