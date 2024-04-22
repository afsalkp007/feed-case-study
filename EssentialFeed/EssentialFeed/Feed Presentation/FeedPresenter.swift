//
//  FeedPresenter.swift
//  EssentialFeed
//
//  Created by Afsal on 22/04/2024.
//

import Foundation

public struct FeedLoadingViewModel {
  public let isLoading: Bool
}

public protocol FeedLoadingView {
  func display(_ viewModel: FeedLoadingViewModel)
}

public struct FeedViewModel {
  public let feed: [FeedImage]
}

public protocol FeedView {
  func display(_ viewModel: FeedViewModel)
}

public struct FeedErrorViewModel {
  public let message: String?
  
  static var noError: FeedErrorViewModel {
    return FeedErrorViewModel(message: .none)
  }
  
  static func error(message: String) -> FeedErrorViewModel {
    return FeedErrorViewModel(message: message)
  }
}

public protocol FeedErrorView {
  func display(_ viewModel: FeedErrorViewModel)
}

final public class FeedPresenter {
  private let feedView: FeedView
  private let loadingView: FeedLoadingView
  private let errorView: FeedErrorView

  public init(feedView: FeedView, loadingView: FeedLoadingView, errorView: FeedErrorView) {
    self.feedView = feedView
    self.loadingView = loadingView
    self.errorView = errorView
  }
  
  public static var title: String {
    return NSLocalizedString(
      "FEED_VIEW_TITLE",
      tableName: "Feed",
      bundle: Bundle(for: FeedPresenter.self),
      comment: "Title for the feed view"
    )
  }
  
  private var loadError: String {
    return NSLocalizedString(
      "FEED_VIEW_CONNECTION_ERROR",
      tableName: "Feed",
      bundle: Bundle(for: FeedPresenter.self),
      comment: "Error message for the feed error view"
    )
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
    errorView.display(.error(message: loadError))
  }
}
