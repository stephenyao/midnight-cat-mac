//
//  ZeroStateViewController.swift
//  midnight-cat-mac
//
//  Created by Stephen Yao on 28/12/18.
//  Copyright © 2018 REA-Group. All rights reserved.
//

import Cocoa

class ZeroStateViewController: NSViewController {

  @IBAction func onAddButtonTapped(_ sender: Any) {
    let window = NSWindow.init()
    window.makeKeyAndOrderFront(nil)
    
    let nextCoordinator = RepositoriesSelectCoordinator()
    nextCoordinator.load(from: window)    
  }
}
