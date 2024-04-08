//
//  FeedViewModel.swift
//  EssentialFeediOS
//
//  Created by Afsal on 08/04/2024.
//

import EssentialFeed

final class FeedViewModel {
  private let feedLoader: FeedLoader
  
  init(feedLoader: FeedLoader) {
    self.feedLoader = feedLoader
  }
  
  var onStateChange: ((FeedViewModel) -> Void)?
  var onRefresh: (([FeedImage]) -> Void)?

  func loadFeed() {
    isLoading = true
    feedLoader.load { [weak self] result in
      if let feed = try? result.get() {
        self?.onRefresh?(feed)
      }
      self?.isLoading = false
    }
  }
  
  var isLoading: Bool = false {
    didSet { onStateChange?(self) }
  }
}
