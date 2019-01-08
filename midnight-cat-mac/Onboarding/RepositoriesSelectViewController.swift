//
//  RepositoriesSelectViewController.swift
//  midnight-cat-mac
//
//  Created by Stephen Yao on 28/12/18.
//  Copyright © 2018 REA-Group. All rights reserved.
//

import Cocoa

struct GitRepository: Storable, Codable {
  var primaryKey: String {
    return self.name
  }
  
  let name: String
  
  var collectionName: String {
    return "repositories"
  }
}

struct RepositoriesSelectViewModel {
  let sectionData: [[GitRepository]]
  
  init(ownedRepositories: [GitRepository], starredRepositories: [GitRepository]) {
    self.sectionData = [ownedRepositories, starredRepositories]
  }
}

class RepositoriesSelectViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate, RepositorySelectTableViewCellDelegate {
  
  var viewModel: RepositoriesSelectViewModel!
  let database: Database = Database()
  
  func numberOfRows(in tableView: NSTableView) -> Int {
    return self.viewModel.sectionData[0].count
  }
  
  func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
    let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cellId"), owner: nil) as? RepositorySelectTableViewCell
        
    let objects: [GitRepository]  = self.database.objects(with: "repositories")
    let isChecked = objects.first { $0.primaryKey == self.viewModel.sectionData[0][row].primaryKey } != nil
    let state: NSButton.StateValue = isChecked ? NSButton.StateValue.on : NSButton.StateValue.off
    
    cell?.configure(title: self.viewModel.sectionData[0][row].name, checkedState:   state)
    cell?.repository = self.viewModel.sectionData[0][row]
    cell?.delegate = self
    
    return cell
  }
  
  func stateChanged(to selected: Bool, forRepository repository: GitRepository) {
    if selected {
      self.database.save(object: repository)
    } else {
      self.database.remove(object: repository)
    }
  }
  
}

protocol RepositorySelectTableViewCellDelegate: class {
  func stateChanged(to selected: Bool, forRepository repository: GitRepository)
}

final class RepositorySelectHandler: RepositorySelectTableViewCellDelegate {
  private let database = Database()
  
  func stateChanged(to selected: Bool, forRepository repository: GitRepository) {
    if selected {
      self.database.save(object: repository)
    } else {
      self.database.remove(object: repository)
    }
  }
}

final class RepositorySelectTableViewCell: NSTableCellView {
  
  weak var delegate: RepositorySelectTableViewCellDelegate?
  
  @IBOutlet var checkBox: NSButton!
  
  var repository: GitRepository!
  
  func configure(title: String, checkedState: NSButton.StateValue) {
    self.textField?.stringValue = title
    self.checkBox.state = checkedState
  }
  
  @IBAction func onCheckButtonTapped(_ sender: NSButton) {
    switch sender.state {
    case NSButton.StateValue.on:
      self.delegate?.stateChanged(to: true, forRepository: repository)
    case NSButton.StateValue.off:
      self.delegate?.stateChanged(to: false, forRepository: repository)
    default: break
    }
  }
  
}
