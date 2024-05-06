//
//  FeedImageDataLoaderPresentationAdapter.swift
//  EssentialFeediOS
//
//  Created by Afsal on 18/04/2024.
//

import Combine
import Foundation
import EssentialFeed
import EssentialFeediOS

final class FeedImageDataLoaderPresentationAdapter<View: FeedImageView, Image>: FeedImageCellControllerDelegate where View.Image == Image {
  private let model: FeedImage
  private let imageLoader: (URL) -> FeedImageDataLoader.Publisher
  private var cancellable: Cancellable?
  
  var presenter: FeedImagePresenter<View, Image>?
  
  init(model: FeedImage, imageLoader: @escaping (URL) -> FeedImageDataLoader.Publisher) {
    self.model = model
    self.imageLoader = imageLoader
  }
  
  func didRequestImage() {
    presenter?.didStartLoadingWithImageData(for: model)
    
    let model = self.model
    cancellable = imageLoader(model.url)
      .dispatchOnMainQueue()
      .sink(
        receiveCompletion: { [weak self] completion in
          switch completion {
          case .finished: break
            
          case let .failure(error):
            self?.presenter?.didFinishLoadingWithImageData(with: error, for: model)
          }
          
        }, receiveValue: { [weak self] data in
          self?.presenter?.didFinishLoadingWithImageData(with: data, for: model)
        })
  }
  
  func didCancelImageRequest() {
    cancellable?.cancel()
    cancellable = nil
  }
}
