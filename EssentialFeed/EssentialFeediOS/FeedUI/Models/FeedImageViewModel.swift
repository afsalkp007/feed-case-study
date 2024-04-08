//
//  FeedImageViewModel.swift
//  EssentialFeediOS
//
//  Created by Afsal on 09/04/2024.
//

import Foundation
import EssentialFeed

final class FeedImageViewModel<Image> {
  typealias Observer<T> = (T) -> Void
  
  private var task: FeedImageDataLoaderTask?
  private let model: FeedImage
  private let imageLoader: FeedImageDataLoader
  private let imageTransformer: (Data) -> Image?
  
  init(model: FeedImage, imageLoader: FeedImageDataLoader, imageTransformer: @escaping (Data) -> Image?) {
    self.model = model
    self.imageLoader = imageLoader
    self.imageTransformer = imageTransformer
  }
  
  var location: String? {
    return model.location
  }
  
  var hasLocation: Bool {
    return location != nil
  }
  
  var description: String? {
    return model.description
  }
  
  var onImageLoad: Observer<Image>?
  var onShouldRetryImageStateChange: Observer<Bool>?
  var onImageLoadingStateChange: Observer<Bool>?
  
  func loadImageData() {
    onShouldRetryImageStateChange?(false)
    onImageLoadingStateChange?(true)
    
    task = imageLoader.loadImageData(from: model.url) { [weak self] result in
      self?.handle(result)
    }
  }
  
  private func handle(_ result: FeedImageDataLoader.Result) {
    if let image = (try? result.get()).flatMap(imageTransformer) {
      onImageLoad?(image)
    } else {
      onShouldRetryImageStateChange?(true)
    }
    onImageLoadingStateChange?(false)
  }
  
  func cancelImageDataLoad() {
    task?.cancel()
    task = nil
  }
}
