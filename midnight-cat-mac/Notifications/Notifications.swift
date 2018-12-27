//
//  Notifications.swift
//  midnight-cat-mac
//
//  Created by Stephen Yao on 27/12/18.
//  Copyright © 2018 REA-Group. All rights reserved.
//

import Foundation

final class AppNotifications {
  static var signInSuccess: Notification.Name = .init("sign-in-success")
  static var signInFailed: Notification.Name = .init("sign-in-failed")
}
