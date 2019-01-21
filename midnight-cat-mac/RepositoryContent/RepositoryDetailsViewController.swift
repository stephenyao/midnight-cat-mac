//
//  RepositoryDetailsViewController.swift
//  midnight-cat-mac
//
//  Created by Stephen Yao on 13/1/19.
//  Copyright © 2019 REA-Group. All rights reserved.
//

import Cocoa

class RepositoryDetailsViewController: NSViewController {
  
  private let repository: GitRepository?
  @IBOutlet var repoNameLabel: NSTextField!
  
  init(repository: GitRepository?) {
    self.repository = repository
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.repoNameLabel.stringValue = self.repository?.name ?? ""
  }
  
}
