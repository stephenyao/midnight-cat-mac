//
//  RepositoryListViewController.swift
//  midnight-cat-mac
//
//  Created by Stephen Yao on 13/1/19.
//  Copyright © 2019 REA-Group. All rights reserved.
//

import Cocoa

struct RepositoryListViewModel {
  let repositories: [GitRepository]
  
  init(repositories: [GitRepository]) {
    self.repositories = repositories
  }
}

class RepositoryListViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
  
  @IBOutlet var tableView: NSTableView!
  private let database: Database = Database()
  private var repositories: [GitRepository]  = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.repositories = self.database.objects(with: "repositories")
    self.tableView.reloadData()
  }
  
  func numberOfRows(in tableView: NSTableView) -> Int {
    return self.repositories.count
  }
  
  func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
    let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cellId"), owner: nil) as? NSTableCellView
    
    let repository = self.repositories[row]
    cell?.textField?.stringValue = repository.name
    
    return cell
  }
  
  func tableViewSelectionDidChange(_ notification: Notification) {
    print("changed")
    let row = self.tableView.selectedRow
    print(row)
  }
  
}
