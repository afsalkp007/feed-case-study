//
//  FeedLoaderPresentationAdapter.swift
//  EssentialFeediOS
//
//  Created by Afsal on 18/04/2024.
//

import Combine
import EssentialFeed
import EssentialFeediOS

final class FeedLoaderPresentationAdapter: FeedViewControllerDelegate {
  private let feedLoader: () -> FeedLoader.Publisher
  private var cancellable: Cancellable?
  var presenter: FeedPresenter?
  
  init(feedLoader: @escaping () -> FeedLoader.Publisher) {
    self.feedLoader = feedLoader
  }
  
  func didRequestFeedRefresh() {
    presenter?.didStartLoadingFeed()
    
    cancellable = feedLoader()
      .dispatchOnMainQueue()
      .sink(
        receiveCompletion: { [weak self] completion in
          switch completion {
          case .finished: break
            
          case let .failure(error):
            self?.presenter?.didFinishLoadingFeed(with: error)
          }
        }, receiveValue: { [weak self] feed in
          self?.presenter?.didFinishLoadingFeed(with: feed)
        })
  }
}
