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

class RepositoriesSelectViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
  
  var viewModel: RepositoriesSelectViewModel!
  
  func numberOfRows(in tableView: NSTableView) -> Int {
    return self.viewModel.sectionData[0].count
  }
  
  func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
    let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cellId"), owner: nil) as? NSTableCellView
    
    cell?.textField?.stringValue = self.viewModel.sectionData[0][row].name ?? ""
    
    return cell
  }
  
}
