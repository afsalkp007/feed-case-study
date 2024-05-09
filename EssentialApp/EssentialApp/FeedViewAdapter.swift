//
//  FeedViewAdapter.swift
//  EssentialFeediOS
//
//  Created by Afsal on 18/04/2024.
//

import UIKit
import EssentialFeed
import EssentialFeediOS

final class FeedViewAdapter: ResourceView {
  private weak var controller: FeedViewController?
  private let imageLoader: (URL) -> FeedImageDataLoader.Publisher
  
  private typealias ImageDataPresentationAdapter = LoadResourcePresentationAdapter<Data, WeakRefVirtualProxy<FeedImageCellController>>

  init(controller: FeedViewController, imageLoader: @escaping (URL) -> FeedImageDataLoader.Publisher) {
    self.controller = controller
    self.imageLoader = imageLoader
  }
  
  public func display(_ viewModel: FeedViewModel) {
    controller?.display(viewModel.feed.map {
      model in
      let adapter = ImageDataPresentationAdapter(loader: { [imageLoader] in
        imageLoader(model.url)
      })
            
      let view = FeedImageCellController(
        viewModel: FeedImagePresenter.map(model),
        delegate: adapter
      )
      
      adapter.presenter = LoadResourcePresenter(
        resourceView: WeakRefVirtualProxy(view),
        loadingView: WeakRefVirtualProxy(view),
        errorView: WeakRefVirtualProxy(view),
        mapper: UIImage.tryMake)
      
      return view
    })
  }
}

private extension UIImage {
  struct InvalidImageData: Error {}

  static func tryMake(_ data: Data) throws -> UIImage {
    guard let image = UIImage(data: data) else {
      throw InvalidImageData()
    }
    return image
  }
}
