//
//  RepositoryDetailsViewController.swift
//  midnight-cat-mac
//
//  Created by Stephen Yao on 13/1/19.
//  Copyright © 2019 REA-Group. All rights reserved.
//

import AppKit

struct GitPullRequest {
  let title: String
  let url: URL?
}

struct RepositoryDetailsViewModel {
  let cloneURL: String
  let pullRequests: [GitPullRequest]
}

class PullRequestDetailCell: NSTableCellView {
  @IBOutlet var titleLabel: NSTextField!
  @IBOutlet var descriptionLabel: NSTextField!
}

class RepositoryDetailsViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
  
  private let viewModel: RepositoryDetailsViewModel
  @IBOutlet var cloneURLLabel: NSTextField!
  @IBOutlet var tableView: NSTableView!
  
  init(viewModel: RepositoryDetailsViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.cloneURLLabel.stringValue = self.viewModel.cloneURL
  }
  
  func numberOfRows(in tableView: NSTableView) -> Int {
    return self.viewModel.pullRequests.count
  }
  
  func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
    let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cellID"), owner: nil) as? PullRequestDetailCell
    let pullRequest = self.viewModel.pullRequests[row]
    cell?.titleLabel.stringValue = pullRequest.title
    
    return cell
  }
  
  func tableViewSelectionDidChange(_ notification: Notification) {
    let selectedRow = self.tableView.selectedRow
    let pullRequest = self.viewModel.pullRequests[selectedRow]
    if let url = pullRequest.url {
      NSWorkspace.shared.open(url)
    }
  }
}
