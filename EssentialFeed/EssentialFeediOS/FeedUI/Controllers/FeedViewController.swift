//
//  FeedViewController.swift
//  EssentialFeediOS
//
//  Created by Afsal on 02/04/2024.
//

import UIKit
import EssentialFeed

public protocol FeedViewControllerDelegate {
  func didRequestFeedRefresh()
}

public final class FeedViewController: UITableViewController, UITableViewDataSourcePrefetching, FeedLoadingView, FeedErrorView {
  @IBOutlet private(set) public var errorView: ErrorView!
  
  private var onViewIsAppearing: ((FeedViewController) -> Void)?
  public var delegate: FeedViewControllerDelegate?
  
  private var loadingControllers = [IndexPath: FeedImageCellController]()

  private var tableModel = [FeedImageCellController]() {
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
  
  public func display(_ cellControllers: [FeedImageCellController]) {
    loadingControllers = [:]
    self.tableModel = cellControllers
  }
  
  public func display(_ viewModel: FeedLoadingViewModel) {
    refreshControl?.update(viewModel.isLoading)
  }
  
  public func display(_ viewModel: FeedErrorViewModel) {
    if let message = viewModel.message {
      errorView.message = message
    } else {
      errorView.message = .none
    }
  }
  
  @IBAction func refresh() {
    delegate?.didRequestFeedRefresh()
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
  
  private func cellController(forRowAt indexPath: IndexPath) -> FeedImageCellController {
    let controller = tableModel[indexPath.row]
    loadingControllers[indexPath] = controller
    return controller
  }
}
