//
//  FeedViewAdapter.swift
//  EssentialFeediOS
//
//  Created by Afsal on 18/04/2024.
//

import UIKit
import EssentialFeed

final class FeedViewAdapter: FeedView {
  private weak var controller: FeedViewController?
  private let imageLoader: FeedImageDataLoader
  
  init(controller: FeedViewController, loader: FeedImageDataLoader) {
    self.controller = controller
    self.imageLoader = loader
  }
  
  public func display(_ viewModel: FeedViewModel) {
    controller?.tableModel = viewModel.feed.map { model in
      let adapter = FeedImageDataLoaderPresentationAdapter<WeakRefVirtualProxy<FeedImageCellController>, UIImage>(model: model, imageLoader: imageLoader)
      let view = FeedImageCellController(delegate: adapter)
      
      adapter.presenter = FeedImagePresenter(
        view: WeakRefVirtualProxy(view),
        imageTransformer: UIImage.init)
      
      return view
    }
  }
}
