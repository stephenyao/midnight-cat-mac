//
//  RepositoryListViewController.swift
//  midnight-cat-mac
//
//  Created by Stephen Yao on 13/1/19.
//  Copyright © 2019 REA-Group. All rights reserved.
//

import Cocoa
import ReactiveSwift

class RepositoryListViewModel: NSObject, NSFetchedResultsControllerDelegate {
  
  let signal: Signal<Void, Never>
  
  private let input: Signal<Void, Never>.Observer
  private let fetchResultsController: NSFetchedResultsController<RepositoryManagedObject>
  
  var numberOfItems: Int {
    return self.fetchResultsController.fetchedObjects?.count ?? 0
  }
  
  init(managedObjectContext: NSManagedObjectContext = CoreDataManagedObjectContext.sharedInstance.context) {
    let (output, input) = Signal<Void, Never>.pipe()
    self.signal = output
    self.input = input
    
    let fetchRequest: NSFetchRequest<RepositoryManagedObject> = RepositoryManagedObject.fetchRequest()
    fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "name", ascending: true)]
    let fetchResultsController = NSFetchedResultsController.init(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
    do {
      try fetchResultsController.performFetch()
    } catch {}
    self.fetchResultsController = fetchResultsController
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    self.input.send(value: ())
  }
  
  func nameOfRepositoryAt(row: Int) -> String {
    return self.fetchResultsController.object(at: IndexPath(item: row, section: 0)).name ?? ""
  }
}

protocol RepositoryListViewControllerDelegate: class {
  
  func repositoryWasSelected(atIndex index: Int)
  
}

class RepositoryListViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
  
  @IBOutlet var tableView: NSTableView!
  
  let viewModel: RepositoryListViewModel
  weak var delegate: RepositoryListViewControllerDelegate?
  
  init(viewModel: RepositoryListViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.viewModel.signal.observe { _ in
      self.tableView.reloadData()
    }
  }
  
  func numberOfRows(in tableView: NSTableView) -> Int {
    return self.viewModel.numberOfItems
  }
  
  func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
    let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cellId"), owner: nil) as? NSTableCellView
    
    let repositoryName = self.viewModel.nameOfRepositoryAt(row: row)
    cell?.textField?.stringValue = repositoryName    
    
    return cell
  }
  
  func tableViewSelectionDidChange(_ notification: Notification) {
    let row = self.tableView.selectedRow
    self.delegate?.repositoryWasSelected(atIndex: row)
  }
  
}
