//
//  SelectRepositoryViewController.swift
//  midnight-cat-mac
//
//  Created by Stephen Yao on 1/6/19.
//  Copyright © 2019 REA-Group. All rights reserved.
//

import Cocoa

struct SelectRepositoryViewModel {
  let repositories: [GitRepository]
  
  init(repositories: [GitRepository]) {
    self.repositories = repositories
  }
  
  var itemCount: Int {
    return self.repositories.count
  }
  
  func itemIsSelectedAtIndex(index: Int) -> Bool {
    return false
  }
  
  func selectedStateAt(index: Int) -> NSButton.StateValue {
    return self.itemIsSelectedAtIndex(index: index) == true ? .on : .off
  }
  
  func repositoryNameAtIndex(index: Int) -> String {
    return self.repositories[index].name
  }
}

class SelectRepositoryViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate, NSFetchedResultsControllerDelegate {
  
  private var fetchResultsController: NSFetchedResultsController<RepositoryManagedObject>!
  private let managedObjectContext: NSManagedObjectContext = CoreDataManagedObjectContext.sharedInstance.context
  private let viewModel: SelectRepositoryViewModel
  
  @IBOutlet var tableView: NSTableView!
  
  init(viewModel: SelectRepositoryViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Select Repositories"
//    let fetchRequest: NSFetchRequest<RepositoryManagedObject> = RepositoryManagedObject.fetchRequest()
//    fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "name", ascending: true)]
//    let fetchResultsController = NSFetchedResultsController.init(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
//    fetchResultsController.delegate = self
//    try! fetchResultsController.performFetch()
//    self.fetchResultsController = fetchResultsController
  }
  
  func numberOfRows(in tableView: NSTableView) -> Int {
    return self.viewModel.itemCount
  }
  
  func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
    let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cellId"), owner: nil) as? RepositorySelectTableViewCell
    let (name, state) = (self.viewModel.repositoryNameAtIndex(index: row), self.viewModel.selectedStateAt(index: row))
    cell?.configure(title: name, checkedState: state) { state in
      print(state)
    }
    
    return cell
  }
  
}
