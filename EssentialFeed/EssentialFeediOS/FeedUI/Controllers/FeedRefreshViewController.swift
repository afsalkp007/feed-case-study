//
//  FeedRefreshController.swift
//  EssentialFeediOS
//
//  Created by Afsal on 06/04/2024.
//

import UIKit
import EssentialFeed

public final class FeedRefreshViewController: NSObject {
  public lazy var view: UIRefreshControl = {
    let view = UIRefreshControl()
    view.addTarget(self, action: #selector(refresh), for: .valueChanged)
    return view
  }()
  
  private let feedLoader: FeedLoader
  
  init(feedLoader: FeedLoader) {
    self.feedLoader = feedLoader
  }
  
  var onRefresh: (([FeedImage]) -> Void)?
  
  @objc func refresh() {
    view.beginRefreshing()
    feedLoader.load { [weak self] result in
      if let feed = try? result.get() {
        self?.onRefresh?(feed)
      }
      self?.view.endRefreshing()
    }
  }
}
