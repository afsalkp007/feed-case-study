//
//  FeedPresenter.swift
//  EssentialFeed
//
//  Created by Afsal on 22/04/2024.
//

import Foundation

public protocol FeedView {
  func display(_ viewModel: FeedViewModel)
}

final public class FeedPresenter {
  private let feedView: FeedView
  private let loadingView: ResourceLoadingView
  private let errorView: ResourceErrorView
  
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

  public init(feedView: FeedView, loadingView: ResourceLoadingView, errorView: ResourceErrorView) {
    self.feedView = feedView
    self.loadingView = loadingView
    self.errorView = errorView
  }
  
  public func didStartLoadingFeed() {
    errorView.display(.noError)
    loadingView.display(ResourceLoadingViewModel(isLoading: true))
  }
  
  public func didFinishLoadingFeed(with feed: [FeedImage]) {
    feedView.display(Self.map(feed))
    loadingView.display(ResourceLoadingViewModel(isLoading: false))
  }
  
  public func didFinishLoadingFeed(with error: Error) {
    loadingView.display(ResourceLoadingViewModel(isLoading: false))
    errorView.display(.error(message: FeedPresenter.loadError))
  }
  
  public static func map(_ feed: [FeedImage]) -> FeedViewModel {
    FeedViewModel(feed: feed)
  }
 }
