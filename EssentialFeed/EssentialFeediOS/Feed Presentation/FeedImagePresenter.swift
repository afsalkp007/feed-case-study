//
//  FeedImagePresenter.swift
//  EssentialFeediOS
//
//  Created by Afsal on 09/04/2024.
//

import Foundation
import EssentialFeed

protocol FeedImageView {
  associatedtype Image
  
  func display(_ viewModel: FeedImageViewModel<Image>)
}

final class FeedImagePresenter<View: FeedImageView, Image> where View.Image == Image {
  private let view: View
  private let imageTransformer: (Data) -> Image?
    
  init(view: View, imageTransformer: @escaping (Data) -> Image?) {
    self.view = view
    self.imageTransformer = imageTransformer
  }
  
  func didStartLoadingWithImageData(for model: FeedImage) {
    view.display(FeedImageViewModel(
      description: model.description,
      location: model.location,
      image: nil,
      isLoading: true,
      shouldRetry: false))
  }
  
  private struct InvalidImageError: Error {}
  
  func didFinishLoadingWithImageData(with data: Data, for model: FeedImage) {
    guard let image = imageTransformer(data) else {
      return didFinishLoadingWithImageData(with: InvalidImageError(), for: model)
    }
    
    view.display(FeedImageViewModel(
      description: model.description,
      location: model.location,
      image: image,
      isLoading: false,
      shouldRetry: false))
  }
  
  func didFinishLoadingWithImageData(with error: Error, for model: FeedImage) {
    view.display(FeedImageViewModel(
      description: model.description,
      location: model.location,
      image: nil,
      isLoading: false,
      shouldRetry: true))
  }
}
