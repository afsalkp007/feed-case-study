//
//  FeedPresenter.swift
//  EssentialFeed
//
//  Created by Afsal on 22/04/2024.
//

import Foundation

public protocol FeedLoadingView {
  func display(_ viewModel: FeedLoadingViewModel)
}

public protocol FeedView {
  func display(_ viewModel: FeedViewModel)
}

public protocol FeedErrorView {
  func display(_ viewModel: FeedErrorViewModel)
}

final public class FeedPresenter {
  private let feedView: FeedView
  private let loadingView: FeedLoadingView
  private let errorView: FeedErrorView
  
  public static var title: String {
    return NSLocalizedString(
      "FEED_VIEW_TITLE",
      tableName: "Feed",
      bundle: Bundle(for: FeedPresenter.self),
      comment: "Title for the feed view"
    )
  }
  
  private static var loadError: String {
    return NSLocalizedString(
      "GENERIC_CONNECTION_ERROR",
      tableName: "Shared",
      bundle: Bundle(for: FeedPresenter.self),
      comment: "Error message for the feed error view"
    )
  }

  public init(feedView: FeedView, loadingView: FeedLoadingView, errorView: FeedErrorView) {
    self.feedView = feedView
    self.loadingView = loadingView
    self.errorView = errorView
  }
  
  public func didStartLoadingFeed() {
    errorView.display(.noError)
    loadingView.display(FeedLoadingViewModel(isLoading: true))
  }
  
  public func didFinishLoadingFeed(with feed: [FeedImage]) {
    feedView.display(FeedViewModel(feed: feed))
    loadingView.display(FeedLoadingViewModel(isLoading: false))
  }
  
  public func didFinishLoadingFeed(with error: Error) {
    loadingView.display(FeedLoadingViewModel(isLoading: false))
    errorView.display(.error(message: FeedPresenter.loadError))
  }
}
