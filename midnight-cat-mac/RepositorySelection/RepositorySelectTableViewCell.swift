//
//  RepositorySelectTableViewCell.swift
//  midnight-cat-mac
//
//  Created by Stephen Yao on 9/1/19.
//  Copyright © 2019 REA-Group. All rights reserved.
//

import Foundation
import AppKit

protocol RepositorySelectTableViewCellDelegate: class {
  func repository(at index: Int, wasSelected selected: Bool)
}

typealias RepositorySelectCellOnTap = (NSButton.StateValue) -> Void

final class RepositorySelectTableViewCell: NSTableCellView {
  
  weak var delegate: RepositorySelectTableViewCellDelegate?
  
  @IBOutlet var checkBox: NSButton!
  
  private var index: Int!
  private var onTap: RepositorySelectCellOnTap!
  
  func configure(title: String, index: Int, checkedState: NSButton.StateValue) {
    self.textField?.stringValue = title
    self.checkBox.state = checkedState
    self.index = index
  }
  
  func configure(title: String, checkedState: NSButton.StateValue, onTap: @escaping RepositorySelectCellOnTap) {
    self.textField?.stringValue = title
    self.checkBox.state = checkedState
    self.onTap = onTap
  }
  
  @IBAction func onCheckButtonTapped(_ sender: NSButton) {
    switch sender.state {
    case NSButton.StateValue.on:
      self.delegate?.repository(at: self.index, wasSelected: true)
    case NSButton.StateValue.off:
      self.delegate?.repository(at: self.index, wasSelected: false)
    default: break
    }
    
    self.onTap(sender.state)
  }
  
}
