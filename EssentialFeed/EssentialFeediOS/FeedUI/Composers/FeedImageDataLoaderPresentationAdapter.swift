//
//  FeedImageDataLoaderPresentationAdapter.swift
//  EssentialFeediOS
//
//  Created by Afsal on 18/04/2024.
//

import EssentialFeed

final class FeedImageDataLoaderPresentationAdapter<View: FeedImageView, Image>: FeedImageCellControllerDelegate where View.Image == Image {
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
