//
//  FeedImageDataLoaderPresentationAdapter.swift
//  EssentialFeediOS
//
//  Created by Afsal on 18/04/2024.
//

import EssentialFeed
import EssentialFeediOS

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
    presenter?.didStartLoadingWithImageData(for: model)
    
    let model = self.model
    task = imageLoader.loadImageData(from: model.url) { [weak self] result in
      switch result {
      case let .success(data):
        self?.presenter?.didFinishLoadingWithImageData(with: data, for: model)
        
      case let .failure(error):
        self?.presenter?.didFinishLoadingWithImageData(with: error, for: model)
      }
    }
  }
  
  func didCancelImageRequest() {
    task?.cancel()
    task = nil
  }
}
