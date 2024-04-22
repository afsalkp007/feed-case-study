//
//  FeedPresenter.swift
//  EssentialFeediOS
//
//  Created by Afsal on 08/04/2024.
//

import Foundation
import EssentialFeed

protocol FeedLoadingView {
  func display(_ viewModel: FeedLoadingViewModel)
}

protocol FeedView {
  func display(_ viewModel: FeedViewModel)
}

protocol FeedErrorView {
  func display(_ viewModel: FeedErrorViewModel)
}

final class FeedPresenter {
  private let feedView: FeedView
  private let loadingView: FeedLoadingView
  private let errorView: FeedErrorView
  
  init(feedView: FeedView, loadingView: FeedLoadingView, errorView: FeedErrorView) {
    self.feedView = feedView
    self.loadingView = loadingView
    self.errorView = errorView
  }
    
  func didStartLoadingFeed() {
    errorView.display(.noError)
    loadingView.display(FeedLoadingViewModel(isLoading: true))
  }
  
  func didFinishLoadingFeed(with feed: [FeedImage]) {
    feedView.display(FeedViewModel(feed: feed))
    loadingView.display(FeedLoadingViewModel(isLoading: false))
  }
  
  func didFinishLoadingFeed(with error: Error) {
    loadingView.display(FeedLoadingViewModel(isLoading: false))
    errorView.display(.errorMessage(Localized.Feed.loadError))
  }
}
