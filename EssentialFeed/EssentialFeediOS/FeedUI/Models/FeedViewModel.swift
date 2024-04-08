//
//  FeedViewModel.swift
//  EssentialFeediOS
//
//  Created by Afsal on 08/04/2024.
//

import EssentialFeed

final class FeedViewModel {
  typealias Observer<T> = (T) -> Void
  private let feedLoader: FeedLoader
  
  init(feedLoader: FeedLoader) {
    self.feedLoader = feedLoader
  }
  
  var onLoadingStateChange: Observer<Bool>?
  var onRefresh: Observer<[FeedImage]>?

  func loadFeed() {
    onLoadingStateChange?(true)
    feedLoader.load { [weak self] result in
      if let feed = try? result.get() {
        self?.onRefresh?(feed)
      }
      self?.onLoadingStateChange?(false)
    }
  }
}
