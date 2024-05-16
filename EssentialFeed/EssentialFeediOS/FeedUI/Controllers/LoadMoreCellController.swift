//
//  LoadMoreCellController.swift
//  EssentialFeediOS
//
//  Created by Afsal on 16/05/2024.
//

import UIKit
import EssentialFeed

public class LoadMoreCellController: NSObject, UITableViewDataSource {
  var cell = LoadMoreCell()
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    1
  }
  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    cell
  }
}

extension LoadMoreCellController: ResourceLoadingView, ResourceErrorView {
  public func display(_ viewModel: ResourceLoadingViewModel) {
    cell.isLoading = viewModel.isLoading
  }
  
  public func display(_ viewModel: ResourceErrorViewModel) {
    cell.message = viewModel.message
  }
}
