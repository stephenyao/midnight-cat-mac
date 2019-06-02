//
//  RepositoryContentViewController.swift
//  midnight-cat-mac
//
//  Created by Stephen Yao on 13/1/19.
//  Copyright © 2019 REA-Group. All rights reserved.
//

import Cocoa
import Octokit
import ReactiveSwift

typealias RepositoryNames = [String]

class RepositoryContentViewModel: NSObject, NSFetchedResultsControllerDelegate {
  
  let repositoryNamesOutput: Signal<RepositoryNames, Never>
  
  private let input: Signal<RepositoryNames, Never>.Observer
  private let fetchResultsController: NSFetchedResultsController<RepositoryManagedObject>
  
  var numberOfItems: Int {
    return self.fetchResultsController.fetchedObjects?.count ?? 0
  }
  
  init(managedObjectContext: NSManagedObjectContext = CoreDataManagedObjectContext.sharedInstance.context) {
    let (output, input) = Signal<RepositoryNames, Never>.pipe()
    self.repositoryNamesOutput = output
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
    let names = self.repositoryNames()
    self.input.send(value: names)
  }
  
  func nameOfRepositoryAt(row: Int) -> String {
    return self.fetchResultsController.object(at: IndexPath(item: row, section: 0)).name ?? ""
  }
  
  func repositoryNames() -> [String] {
    return self.fetchResultsController.fetchedObjects?.compactMap { $0.name } ?? []
  }
  
  func repositoryName(atRow row: Int) -> String {
    return self.repositoryNames()[row]
  }
  
  func repositoryOwner(atRow row: Int) -> String {
    return self.fetchResultsController.object(at: IndexPath(item: row, section: 0)).owner ?? ""
  }
  
  func repositoryCloneURL(atRow row: Int) -> URL? {
    return self.fetchResultsController.object(at: IndexPath(item: row, section: 0)).cloneURL
  }
  
  func repositoryID(atRow row: Int) -> Int {
    return Int(self.fetchResultsController.object(at: IndexPath(item: row, section: 0)).id)
  }
}

class RepositoryContentViewController: NSSplitViewController, RepositoryListViewControllerDelegate {
  
  private var rightSplitViewItem: NSSplitViewItem!
  private let viewModel = RepositoryContentViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()

    let repositoryNames = self.viewModel.repositoryNames()
    let viewModel = RepositoryListViewModel(repositoryNames: repositoryNames)
    let listViewController = RepositoryListViewController(viewModel: viewModel)
    listViewController.delegate = self
    
    self.viewModel.repositoryNamesOutput.observeValues { names in
      listViewController.viewModel = RepositoryListViewModel(repositoryNames: repositoryNames)
    }
    
    let left = NSSplitViewItem(sidebarWithViewController: listViewController)
    left.minimumThickness = 250
    left.maximumThickness = 250
    left.preferredThicknessFraction = 0.2
    
    let right = NSSplitViewItem(contentListWithViewController: RepositoryContentEmptyDetailViewController())
    self.setupRightSplitItemAttributes(for: right)
    
    self.addSplitViewItem(left)
    self.addSplitViewItem(right)
    
    self.rightSplitViewItem = right
    self.splitView.dividerStyle = .thin
  }
  
  func repositoryWasSelected(atIndex index: Int) {
    guard index != -1 else { return }
    let (name, owner, repositoryID, cloneURL) =
      (self.viewModel.repositoryName(atRow: index),
       self.viewModel.repositoryOwner(atRow: index),
       self.viewModel.repositoryID(atRow: index),
       self.viewModel.repositoryCloneURL(atRow: index))
    
    guard let config = AppState.sharedInstance.octokitConfig else {
      return
    }        
  
    let _ = Octokit(config).pullRequests(owner: owner, repository: name) { (response) in
      switch response {
      case .success(let pullRequests):
        DispatchQueue.main.async {
          self.removeSplitViewItem(self.rightSplitViewItem)
          let pullRequests = pullRequests.compactMap { pullRequestData -> GitPullRequest? in
            return GitPullRequest(octoKitPullRequest: pullRequestData, repositoryID: repositoryID)
          }
          let repositoryDetailViewModel = RepositoryDetailsViewModel(cloneURL: cloneURL?.absoluteString ?? "", pullRequests: pullRequests)
          let detailsViewController = RepositoryDetailsViewController(viewModel: repositoryDetailViewModel)
          let newRightSplitViewItem = NSSplitViewItem(contentListWithViewController: detailsViewController)
          self.setupRightSplitItemAttributes(for: newRightSplitViewItem)
          self.addSplitViewItem(newRightSplitViewItem)
          self.rightSplitViewItem = newRightSplitViewItem
        }
      case .failure(let error):
        print(error)
      }
    }
  }
  
  private func setupRightSplitItemAttributes(for item: NSSplitViewItem) {
    item.minimumThickness = 350
//    item.maximumThickness = 1000
  }
  
}
