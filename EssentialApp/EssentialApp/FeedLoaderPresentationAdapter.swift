//
//  FeedLoaderPresentationAdapter.swift
//  EssentialFeediOS
//
//  Created by Afsal on 18/04/2024.
//

import EssentialFeed
import EssentialFeediOS

final class FeedLoaderPresentationAdapter: FeedViewControllerDelegate {
  private let feedLoader: FeedLoader
  var presenter: FeedPresenter?
  
  init(feedLoader: FeedLoader) {
    self.feedLoader = feedLoader
  }
  
  func didRequestFeedRefresh() {
    presenter?.didStartLoadingFeed()
    
    feedLoader.load { [weak self] result in
      switch result {
      case let .success(feed):
        self?.presenter?.didFinishLoadingFeed(with: feed)
        
      case let .failure(error):
        self?.presenter?.didFinishLoadingFeed(with: error)
      }
    }
  }
}