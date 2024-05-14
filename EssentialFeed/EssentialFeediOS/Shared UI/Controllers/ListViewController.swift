//
//  FeedViewController.swift
//  EssentialFeediOS
//
//  Created by Afsal on 02/04/2024.
//

import UIKit
import EssentialFeed

public final class ListViewController: UITableViewController {
  private(set) public var errorView = ErrorView()
  
  private var onViewIsAppearing: ((ListViewController) -> Void)?
  public var onRefresh: (() -> Void)?
  
  private lazy var dataSource: UITableViewDiffableDataSource<Int, CellController> = {
    .init(tableView: tableView) { tableView, index, controller -> UITableViewCell? in
      return controller.dataSource.tableView(tableView, cellForRowAt: index)
    }
  }()
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    configureTableView()
    configureTraitCollectionObservers()
    onViewIsAppearing = { vc in
      vc.onViewIsAppearing = nil
      vc.refresh()
    }
  }
  
  public override func viewIsAppearing(_ animated: Bool) {
    super.viewIsAppearing(animated)
    
    onViewIsAppearing?(self)
  }
  
  private func configureTableView() {
    dataSource.defaultRowAnimation = .fade
    tableView.dataSource = dataSource
    tableView.tableHeaderView = errorView.makeContainer()
    
    errorView.onHide = { [weak self] in
      self?.tableView.beginUpdates()
      self?.tableView.sizeTableHeaderToFit()
      self?.tableView.endUpdates()
    }
  }
  
  private func configureTraitCollectionObservers() {
    registerForTraitChanges(
      [UITraitPreferredContentSizeCategory.self]
    ) { (self: Self, previous: UITraitCollection) in
      self.tableView.reloadData()
    }
  }
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    tableView.sizeTableHeaderToFit()
  }
  
  public func display(_ cellControllers: [CellController]) {
    var snapshot = NSDiffableDataSourceSnapshot<Int, CellController>()
    snapshot.appendSections([0])
    snapshot.appendItems(cellControllers, toSection: 0)
    dataSource.applySnapshotUsingReloadData(snapshot)
  }
  
  @IBAction func refresh() {
    onRefresh?()
  }
}
 
extension ListViewController: ResourceLoadingView, ResourceErrorView {
  public func display(_ viewModel: ResourceLoadingViewModel) {
    refreshControl?.update(viewModel.isLoading)
  }
  
  public func display(_ viewModel: ResourceErrorViewModel) {
    errorView.message = viewModel.message
  }
}
 
extension ListViewController: UITableViewDataSourcePrefetching {
  public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let dl = cellController(at: indexPath)?.delegate
    dl?.tableView?(tableView, didSelectRowAt: indexPath)
  }
    
  public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    let dl = cellController(at: indexPath)?.delegate
    dl?.tableView?(tableView, didEndDisplaying: cell, forRowAt: indexPath)
  }
  
  public override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    let dsp = cellController(at: indexPath)?.dataSourcePrefetching
    dsp?.tableView(tableView, prefetchRowsAt: [indexPath])
  }
  
  public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    indexPaths.forEach { indexPath in
      let dsp = cellController(at: indexPath)?.dataSourcePrefetching
      dsp?.tableView(tableView, prefetchRowsAt: [indexPath])
    }
  }
  
  public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
    indexPaths.forEach { indexPath in
      let dsp = cellController(at: indexPath)?.dataSourcePrefetching
      dsp?.tableView?(tableView, cancelPrefetchingForRowsAt: [indexPath])
    }
  }
    
  private func cellController(at indexPath: IndexPath) -> CellController? {
    dataSource.itemIdentifier(for: indexPath)
  }
}
