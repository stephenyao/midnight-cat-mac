//
//  RepositoryContentViewController.swift
//  midnight-cat-mac
//
//  Created by Stephen Yao on 13/1/19.
//  Copyright © 2019 REA-Group. All rights reserved.
//

import Cocoa

class RepositoryContentViewController: NSSplitViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    let left = NSSplitViewItem(sidebarWithViewController: RepositoryListViewController.init(nibName: nil, bundle: nil))
    let right = NSSplitViewItem(contentListWithViewController: RepositoryDetailsViewController.init(nibName: nil, bundle: nil))
    
    self.addSplitViewItem(left)
    self.addSplitViewItem(right)
  }
  
}
