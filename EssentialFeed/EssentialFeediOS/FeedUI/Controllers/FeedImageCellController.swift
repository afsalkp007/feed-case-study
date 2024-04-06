//
//  FeedImageCellController.swift
//  EssentialFeediOS
//
//  Created by Afsal on 06/04/2024.
//

import UIKit
import EssentialFeed

final class FeedImageCellController {
  private var task: FeedImageDataLoaderTask?
  private let model: FeedImage
  private let imageLoader: FeedImageDataLoader
  
  init(model: FeedImage, imageLoader: FeedImageDataLoader) {
    self.model = model
    self.imageLoader = imageLoader
  }
  
  func view() -> UITableViewCell {
    let cell = FeedImageCell()
    cell.locationContainer.isHidden = (model.location == nil)
    cell.locationLabel.text = model.location
    cell.descriptinoLabel.text = model.description
    cell.feedImageView.image = nil
    cell.feedImageRetryButton.isHidden = true
    cell.feedImageContainer.startShimmering()
    
    let loadImage = { [weak self] in
      guard let self = self else { return }
      
      task = imageLoader.loadImageData(from: model.url) { [weak cell] result in
        let data = try? result.get()
        let image = data.map(UIImage.init) ?? nil
        cell?.feedImageView.image = image
        cell?.feedImageRetryButton.isHidden = (image != nil)
        cell?.feedImageContainer.stopShimmering()
      }
    }
    
    cell.onRetry = loadImage
    loadImage()
    
    return cell
  }
  
  func preload() {
    task = imageLoader.loadImageData(from: model.url) { _ in }
  }
  
  deinit {
    task?.cancel()
    task = nil
  }
}
