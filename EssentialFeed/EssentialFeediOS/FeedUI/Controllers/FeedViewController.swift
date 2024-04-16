//
//  FeedViewController.swift
//  EssentialFeediOS
//
//  Created by Afsal on 02/04/2024.
//

import UIKit

public final class FeedViewController: UITableViewController, UITableViewDataSourcePrefetching {
  private var onViewIsAppearing: ((FeedViewController) -> Void)?
  @IBOutlet public var refreshController: FeedRefreshViewController?
  var tableModel = [FeedImageCellController]() {
    didSet { tableView.reloadData() }
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.prefetchDataSource = self
    
    onViewIsAppearing = { vc in
      vc.refreshController?.refresh()
      vc.onViewIsAppearing = nil
    }
  }
  
  public override func viewIsAppearing(_ animated: Bool) {
    super.viewIsAppearing(animated)
    
    onViewIsAppearing?(self)
  }
    
  public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tableModel.count
  }
  
  public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return cellController(forRowAt: indexPath).view()
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
    cellController(forRowAt: indexPath).cancelLoad()
  }
  
  private func cellController(forRowAt indexPath: IndexPath) -> FeedImageCellController {
    return tableModel[indexPath.row]
  }
}
