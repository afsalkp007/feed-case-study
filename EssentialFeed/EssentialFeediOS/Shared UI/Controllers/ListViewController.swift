//
//  FeedViewController.swift
//  EssentialFeediOS
//
//  Created by Afsal on 02/04/2024.
//

import UIKit
import EssentialFeed

public protocol CellController {
  func view(in tableView: UITableView) -> UITableViewCell
  func preload()
  func cancelLoad()
}

public extension CellController {
  func preload() {}
  func cancelLoad() {}
}

public final class ListViewController: UITableViewController, UITableViewDataSourcePrefetching, ResourceLoadingView, ResourceErrorView {
  @IBOutlet private(set) public var errorView: ErrorView!
  
  private var onViewIsAppearing: ((ListViewController) -> Void)?
  
  public var onRefresh: (() -> Void)?
  
  private var loadingControllers = [IndexPath: CellController]()

  private var tableModel = [CellController]() {
    didSet { tableView.reloadData() }
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
        
    onViewIsAppearing = { vc in
      vc.refresh()
      vc.onViewIsAppearing = nil
    }
  }
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    tableView.sizeTableHeaderToFit()
  }
  
  public override func viewIsAppearing(_ animated: Bool) {
    super.viewIsAppearing(animated)
    
    onViewIsAppearing?(self)
  }
  
  public func display(_ cellControllers: [CellController]) {
    loadingControllers = [:]
    self.tableModel = cellControllers
  }
  
  public func display(_ viewModel: ResourceLoadingViewModel) {
    refreshControl?.update(viewModel.isLoading)
  }
  
  public func display(_ viewModel: ResourceErrorViewModel) {
    errorView.message = viewModel.message
  }
  
  @IBAction func refresh() {
    onRefresh?()
  }
    
  public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tableModel.count
  }
  
  public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return cellController(forRowAt: indexPath).view(in: tableView)
  }
  
  public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    removeCellController(forRowAt: indexPath)
  }
  
  public override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    cellController(forRowAt: indexPath).preload()
  }
  
  public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    indexPaths.forEach { indexPath in
      cellController(forRowAt: indexPath).preload()
    }
  }
  
  public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
    indexPaths.forEach(removeCellController)
  }
  
  private func removeCellController(forRowAt indexPath: IndexPath) {
    loadingControllers[indexPath]?.cancelLoad()
    loadingControllers[indexPath] = nil
  }
  
  private func cellController(forRowAt indexPath: IndexPath) -> CellController {
    let controller = tableModel[indexPath.row]
    loadingControllers[indexPath] = controller
    return controller
  }
}
