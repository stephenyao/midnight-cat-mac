//
//  NSWindowController+Extensions.swift
//  midnight-cat-mac
//
//  Created by Stephen Yao on 1/6/19.
//  Copyright © 2019 REA-Group. All rights reserved.
//

import Cocoa

extension NSWindowController {
  override open func keyDown(with event: NSEvent) {
    if event.modifierFlags.contains(.command) {
      switch event.charactersIgnoringModifiers {
      case "w":
        self.window?.close()
      default:
        break
      }
    }
  }
}
