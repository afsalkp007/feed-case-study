//
//  FeedUIComposer.swift
//  EssentialFeediOS
//
//  Created by Afsal on 06/04/2024.
//

import UIKit
import EssentialFeed

public final class FeedUIComposer {
  private init() {}
  
  public static func feedComposedWith(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) -> FeedViewController {
    let feedPresenter = FeedPresenter(feedLoader: feedLoader)
    let refreshController = FeedRefreshViewController(presenter: feedPresenter)
    let feedController = FeedViewController(refreshController: refreshController)
    feedPresenter.loadingView = refreshController
    feedPresenter.feedView = FeedViewAdapter(controller: feedController, loader: imageLoader)
    return feedController
  }
}

private final class FeedViewAdapter: FeedView {
  private weak var controller: FeedViewController?
  private let loader: FeedImageDataLoader
  
  init(controller: FeedViewController, loader: FeedImageDataLoader) {
    self.controller = controller
    self.loader = loader
  }
  
  func display(feed: [FeedImage]) {
    controller?.tableModel = feed.map { model in
      FeedImageCellController(viewModel: FeedImageViewModel(model: model, imageLoader: loader, imageTransformer: UIImage.init))
    }
  }
}
