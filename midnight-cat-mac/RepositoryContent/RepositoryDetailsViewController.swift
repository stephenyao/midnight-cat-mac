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
  let createdAt: Date
  let author: String
  let number: Int
}

struct RepositoryDetailsViewModel {
  let cloneURL: String
  let pullRequests: [GitPullRequest]
}

protocol PullRequestDetailCellDelegate: class {
  
  func viewOnWebButtonClicked(sender: NSView)
  
}

class PullRequestDetailCell: NSTableCellView {
  @IBOutlet var titleLabel: NSTextField!
  @IBOutlet var descriptionLabel: NSTextField!
  weak var delegate: PullRequestDetailCellDelegate?
  
  func configure(title: String, description: String) {
    self.titleLabel.stringValue = title
    self.descriptionLabel.stringValue = description
  }
  
  @IBAction func onViewOnWebClicked(_ sender: Any) {
    self.delegate?.viewOnWebButtonClicked(sender: self)
  }
}

class RepositoryDetailsViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource, PullRequestDetailCellDelegate {
  
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
    let description = "#\(pullRequest.number) opened \(pullRequest.createdAt.getElapsedInterval()) ago by \(pullRequest.author)"
    
    cell?.configure(title: pullRequest.title, description: description)
    cell?.delegate = self
    
    return cell
  }
  
  func viewOnWebButtonClicked(sender: NSView) {
    let row = self.tableView.row(for: sender)
    let pullRequest = self.viewModel.pullRequests[row]
    if let url = pullRequest.url {
      NSWorkspace.shared.open(url)
    }
  }
  
  @IBAction func onCopyCloneURLClicked(_ sender: Any) {
    let pasteboard = NSPasteboard.general
    pasteboard.declareTypes([.string], owner: nil)
    pasteboard.setString(self.cloneURLLabel.stringValue, forType: .string)
  }
}

extension Date {
  
  func getElapsedInterval() -> String {
    
    let interval = Calendar.current.dateComponents([.year, .month, .day], from: self, to: Date())
    
    if let year = interval.year, year > 0 {
      return year == 1 ? "\(year)" + " " + "year" :
        "\(year)" + " " + "years"
    } else if let month = interval.month, month > 0 {
      return month == 1 ? "\(month)" + " " + "month" :
        "\(month)" + " " + "months"
    } else if let day = interval.day, day > 0 {
      return day == 1 ? "\(day)" + " " + "day" :
        "\(day)" + " " + "days"
    } else {
      return "a moment ago"
      
    }
    
  }
}
