//
//  SelectRepositoryViewController.swift
//  midnight-cat-mac
//
//  Created by Stephen Yao on 1/6/19.
//  Copyright © 2019 REA-Group. All rights reserved.
//

import Cocoa

class SelectRepositoryViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate, NSFetchedResultsControllerDelegate, RepositorySelectTableViewCellDelegate {
  
  private var fetchResultsController: NSFetchedResultsController<RepositoryManagedObject>!
  @IBOutlet var tableView: NSTableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let fetchRequest: NSFetchRequest<RepositoryManagedObject> = RepositoryManagedObject.fetchRequest()
    fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "name", ascending: true)]
    let fetchResultsController = NSFetchedResultsController.init(fetchRequest: fetchRequest, managedObjectContext: CoreDataManagedObjectContext.sharedInstance.context, sectionNameKeyPath: nil, cacheName: nil)
    fetchResultsController.delegate = self
    try! fetchResultsController.performFetch()
    self.fetchResultsController = fetchResultsController    
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    self.tableView.reloadData()
  }
  
  func numberOfRows(in tableView: NSTableView) -> Int {
    return self.fetchResultsController.fetchedObjects?.count ?? 0
  }
  
  func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
    let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cellId"), owner: nil) as? RepositorySelectTableViewCell
    let repository = self.fetchResultsController.fetchedObjects?[row]
    cell?.delegate = self
    cell?.configure(title: repository?.name ?? "", index: row, checkedState: .off)
    return cell
  }
  
  func repository(at index: Int, wasSelected selected: Bool) {
    guard let object = self.fetchResultsController.fetchedObjects?[index] else {
      return
    }
    object.selected = !object.selected
    try! CoreDataManagedObjectContext.sharedInstance.context.save()
  }
  
}
