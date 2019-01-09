//
//  RepositoriesSelectViewController.swift
//  midnight-cat-mac
//
//  Created by Stephen Yao on 28/12/18.
//  Copyright © 2018 REA-Group. All rights reserved.
//

import Cocoa

struct RepositoriesSelectViewModel {
  let repositories: [GitRepository]
  
  init(repositories: [GitRepository]) {
    self.repositories = repositories
  }
}

class RepositoriesSelectViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate, RepositorySelectTableViewCellDelegate {
  
  var viewModel: RepositoriesSelectViewModel!
  let database: Database = Database()
  
  func numberOfRows(in tableView: NSTableView) -> Int {
    return self.viewModel.repositories.count
  }
  
  func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
    let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cellId"), owner: nil) as? RepositorySelectTableViewCell
        
    let objects: [GitRepository]  = self.database.objects(with: "repositories")
    let isChecked = objects.first { $0.primaryKey == self.viewModel.repositories[row].primaryKey } != nil
    let state: NSButton.StateValue = isChecked ? NSButton.StateValue.on : NSButton.StateValue.off
    let repository = self.viewModel.repositories[row]
    cell?.configure(title: repository.name, index: row, checkedState: state)
    cell?.delegate = self
    
    return cell
  }
  
  func repository(at index: Int, wasSelected selected: Bool) {
    let repository = self.viewModel.repositories[index]
    if selected {
      self.database.save(object: repository)
    } else {
      self.database.remove(object: repository)
    }
  }
}
