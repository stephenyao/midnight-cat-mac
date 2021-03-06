//
//  SelectRepositoryViewController.swift
//  midnight-cat-mac
//
//  Created by Stephen Yao on 1/6/19.
//  Copyright © 2019 REA-Group. All rights reserved.
//

import Cocoa
import ReactiveSwift

struct SelectRepositoryViewModel {
  
  let signal: Signal<Void, Never>
  private let input: Signal<Void, Never>.Observer
  private let repositories: [GitRepository]
  private let managedObjectContext: NSManagedObjectContext = CoreDataManagedObjectContext.sharedInstance.context
  private let managedObjectFetcher: CoreDataManagedObjectFetcher = CoreDataManagedObjectFetcher.sharedInstance

  init(repositories: [GitRepository]) {
    self.repositories = repositories
    let (output, input) = Signal<Void, Never>.pipe()
    self.signal = output
    self.input = input
  }
  
  var itemCount: Int {
    return self.repositories.count
  }
  
  func itemIsSelectedAtIndex(index: Int) -> Bool {
    do {
      let repository = self.repositories[index]
      let fetchRequest: NSFetchRequest<RepositoryManagedObject> = RepositoryManagedObject.fetchRequest()
      fetchRequest.predicate = NSPredicate(format: "id == %d", repository.id)
      let results = try self.managedObjectContext.fetch(fetchRequest)
      return results.count > 0
    } catch {
      return false
    }
  }
  
  func selectedStateAt(index: Int) -> NSButton.StateValue {
    return self.itemIsSelectedAtIndex(index: index) == true ? .on : .off
  }
  
  func repositoryNameAtIndex(index: Int) -> String {
    return self.repositories[index].name
  }
  
  func onCellStateChanged(atIndex index: Int) {
    do {
      let repository = self.repositories[index]
      if let repository = self.managedObjectFetcher.repositoryManagedObject(withID: repository.id, managedObjectContext: self.managedObjectContext) {
        self.managedObjectContext.delete(repository)
      } else {
        NSEntityDescription.repositoryEntity(forRepository: repository, withContext: self.managedObjectContext)
        try self.managedObjectContext.save()
      }
    } catch (let error) {
      print(error.localizedDescription)
    }
    
    self.input.send(value: ())
  }
}

class SelectRepositoryViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate, NSFetchedResultsControllerDelegate {
  
  private var fetchResultsController: NSFetchedResultsController<RepositoryManagedObject>!
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
    self.viewModel.signal.observeValues {
      self.tableView.reloadData()
    }
  }
  
  func numberOfRows(in tableView: NSTableView) -> Int {
    return self.viewModel.itemCount
  }
  
  func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
    let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cellId"), owner: nil) as? RepositorySelectTableViewCell
    let (name, state) = (self.viewModel.repositoryNameAtIndex(index: row), self.viewModel.selectedStateAt(index: row))
    cell?.configure(title: name, checkedState: state) { state in
      self.viewModel.onCellStateChanged(atIndex: row)
    }
    
    return cell
  }
  
}
