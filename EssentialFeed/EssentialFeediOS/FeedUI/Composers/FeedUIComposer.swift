//
//  FeedUIComposer.swift
//  EssentialFeediOS
//
//  Created by Afsal on 06/04/2024.
//

import EssentialFeed

public final class FeedUIComposer {
  private init() {}
  
  public static func feedComposedWith(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) -> FeedViewController {
    let viewModel = FeedViewModel(feedLoader: feedLoader)
    let refreshController = FeedRefreshViewController(viewModel: viewModel)
    let feedController = FeedViewController(refreshController: refreshController)
    viewModel.onRefresh = adaptFeedToCellControllers(forwardingTo: feedController, loader: imageLoader)
    return feedController
  }
  
  private static func adaptFeedToCellControllers(forwardingTo controller: FeedViewController, loader: FeedImageDataLoader) -> ([FeedImage]) -> Void {
    return { [weak controller] feed in
      controller?.tableModel = feed.map { model in
        FeedImageCellController(viewModel: FeedImageViewModel(model: model, imageLoader: loader))
      }
    }
  }
}
