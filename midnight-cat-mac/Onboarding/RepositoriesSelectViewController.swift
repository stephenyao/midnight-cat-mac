//
//  RepositoriesSelectViewController.swift
//  midnight-cat-mac
//
//  Created by Stephen Yao on 28/12/18.
//  Copyright © 2018 REA-Group. All rights reserved.
//

import Cocoa
import Octokit

struct RepositoriesSelectViewModel {
  let sectionData: [[Repository]]
  
  init(ownedRepositories: [Repository], starredRepositories: [Repository]) {
    self.sectionData = [ownedRepositories, starredRepositories]
  }
}

class RepositoriesSelectViewController: NSViewController {
  
  var viewModel: RepositoriesSelectViewModel!
  
}
