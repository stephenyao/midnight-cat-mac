//
//  SelectRepositoriesLoadingViewController.swift
//  midnight-cat-mac
//
//  Created by Stephen Yao on 1/6/19.
//  Copyright © 2019 REA-Group. All rights reserved.
//

import Cocoa

class SelectRepositoriesLoadingViewController: NSViewController {
  
  @IBOutlet var progressIndicator: NSProgressIndicator!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Loading Repositories"
    self.progressIndicator.startAnimation(nil)
  }
  
}
