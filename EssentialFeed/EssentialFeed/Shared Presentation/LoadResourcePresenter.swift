//
//  LoadResourcePresenter.swift
//  EssentialFeed
//
//  Created by Afsal on 22/04/2024.
//

import Foundation

public protocol ResourceView {
  func display(_ viewModel: String)
}

public final class LoadResourcePresenter {
  public typealias Mapper = (String) -> String
  
  private let resourceView: ResourceView
  private let loadingView: FeedLoadingView
  private let errorView: FeedErrorView
  private let mapper: Mapper

  public init(resourceView: ResourceView, loadingView: FeedLoadingView, errorView: FeedErrorView, mapper: @escaping Mapper) {
    self.resourceView = resourceView
    self.loadingView = loadingView
    self.errorView = errorView
    self.mapper = mapper
  }
  
  public func didStartLoading() {
    errorView.display(.noError)
    loadingView.display(FeedLoadingViewModel(isLoading: true))
  }
  
  public func didFinishLoading(with resource: String) {
    resourceView.display(mapper(resource))
    loadingView.display(FeedLoadingViewModel(isLoading: false))
  }
  
  public func didFinishLoadingFeed(with error: Error) {
    loadingView.display(FeedLoadingViewModel(isLoading: false))
    errorView.display(.error(message: Localized.Feed.loadError))
  }
}
