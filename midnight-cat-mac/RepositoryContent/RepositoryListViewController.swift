//
//  RepositoryListViewController.swift
//  midnight-cat-mac
//
//  Created by Stephen Yao on 13/1/19.
//  Copyright © 2019 REA-Group. All rights reserved.
//

import Cocoa

struct RepositoryListViewModel {
  let repositoryNames: [String]
}

protocol RepositoryListViewControllerDelegate: class {
  
  func repositoryWasSelected(atIndex index: Int)
  
}

class RepositoryListViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
  
  @IBOutlet var tableView: NSTableView!
  
  var viewModel: RepositoryListViewModel {
    didSet {
      self.tableView.reloadData()
    }
  }
  
  weak var delegate: RepositoryListViewControllerDelegate?
  
  init(viewModel: RepositoryListViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func numberOfRows(in tableView: NSTableView) -> Int {
    return self.viewModel.repositoryNames.count
  }
  
  func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
    let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cellId"), owner: nil) as? NSTableCellView
    
    let repositoryName = self.viewModel.repositoryNames[row]
    cell?.textField?.stringValue = repositoryName    
    
    return cell
  }
  
  func tableViewSelectionDidChange(_ notification: Notification) {
    let row = self.tableView.selectedRow
    self.delegate?.repositoryWasSelected(atIndex: row)
  }
  
}
