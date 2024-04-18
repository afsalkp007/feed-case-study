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
    let presentationAdapter = FeedLoaderPresentationAdapter(
      feedLoader: MainQueueDispatchDecorator(decoratee: feedLoader)
    )
    
    let feedController = FeedViewController.makeWith(
      delegate: presentationAdapter,
      title: FeedPresenter.title
    )
    
    presentationAdapter.presenter = FeedPresenter(
      feedView: FeedViewAdapter(
        controller: feedController,
        loader: MainQueueDispatchDecorator(decoratee: imageLoader)
      ),
      loadingView: WeakRefVirtualProxy(feedController)
    )
    
    return feedController
  }
}

private extension FeedViewController {
  static func makeWith(delegate: FeedViewControllerDelegate, title: String) -> FeedViewController {
    let bundle = Bundle(for: FeedViewController.self)
    let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
    let feedController = storyboard.instantiateInitialViewController() as! FeedViewController
    feedController.delegate = delegate
    feedController.title = title
    return feedController
  }
}

private final class WeakRefVirtualProxy<T: AnyObject> {
  private weak var object: T?
  
  init(_ object: T) {
    self.object = object
  }
}

extension WeakRefVirtualProxy: FeedLoadingView where T: FeedLoadingView {
  func display(_ viewModel: FeedLoadingViewModel) {
    object?.display(viewModel)
  }
}

extension WeakRefVirtualProxy: FeedImageView where T: FeedImageView, T.Image == UIImage {
  func display(_ viewModel: FeedImageViewModel<UIImage>) {
    object?.display(viewModel)
  }
}

private final class FeedViewAdapter: FeedView {
  private weak var controller: FeedViewController?
  private let imageLoader: FeedImageDataLoader
  
  init(controller: FeedViewController, loader: FeedImageDataLoader) {
    self.controller = controller
    self.imageLoader = loader
  }
  
  func display(_ viewModel: FeedViewModel) {
    controller?.tableModel = viewModel.feed.map { model in
      let adapter = FeedImageDataPresentationAdapter<WeakRefVirtualProxy<FeedImageCellController>, UIImage>(model: model, imageLoader: imageLoader)
      let view = FeedImageCellController(delegate: adapter)
      
      adapter.presenter = FeedImagePresenter(
        view: WeakRefVirtualProxy(view),
        imageTransformer: UIImage.init)
      
      return view
    }
  }
}

private final class FeedImageDataPresentationAdapter<View: FeedImageView, Image>: FeedImageCellControllerDelegate where View.Image == Image {
  private let model: FeedImage
  private let imageLoader: FeedImageDataLoader
  private var task: FeedImageDataLoaderTask?
  
  var presenter: FeedImagePresenter<View, Image>?
  
  init(model: FeedImage, imageLoader: FeedImageDataLoader) {
    self.model = model
    self.imageLoader = imageLoader
  }
  
  func didRequestImage() {
    presenter?.didStartLoading(for: model)
    
    let model = self.model
    task = imageLoader.loadImageData(from: model.url) { [weak self] result in
      switch result {
      case let .success(data):
        self?.presenter?.didFinishLoading(with: data, for: model)
        
      case let .failure(error):
        self?.presenter?.didFinishLoading(with: error, for: model)
      }
    }
  }
  
  func didCancelImageRequest() {
    task?.cancel()
    task = nil
  }
}

private final class FeedLoaderPresentationAdapter: FeedViewControllerDelegate {
  private let feedLoader: FeedLoader
  var presenter: FeedPresenter?
  
  init(feedLoader: FeedLoader) {
    self.feedLoader = feedLoader
  }
  
  func didRequestFeedRefresh() {
    presenter?.didStartLoadingFeed()
    
    feedLoader.load { [weak self] result in
      switch result {
      case let .success(feed):
        self?.presenter?.didFinishLoadingFeed(with: feed)
        
      case let .failure(error):
        self?.presenter?.didFinishLoadingFeed(with: error)
      }
    }
  }
}