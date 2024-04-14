//
//  FeedImageCellController.swift
//  EssentialFeediOS
//
//  Created by Afsal on 06/04/2024.
//

import UIKit

protocol FeedImageCellControllerDelegate {
  func didRequestImage()
  func didCancelImageRequest()
}

final class FeedImageCellController: FeedImageView {
  private var delegate: FeedImageCellControllerDelegate
  private lazy var cell = FeedImageCell()
  
  init(delegate: FeedImageCellControllerDelegate) {
    self.delegate = delegate
  }
  
  func view() -> UITableViewCell {
    delegate.didRequestImage()
    return cell
  }
  
  func display(_ viewModel: FeedImageModel<UIImage>) {
    cell.locationContainer.isHidden = !viewModel.hasLocation
    cell.locationLabel.text = viewModel.location
    cell.descriptinoLabel.text = viewModel.description
    
    cell.feedImageView.image = viewModel.image
    cell.feedImageContainer.isShimmering = viewModel.isLoading
    cell.feedImageRetryButton.isHidden = !viewModel.shouldRetry
    
    cell.onRetry = delegate.didRequestImage
  }
  
  func preload() {
    delegate.didRequestImage()
  }
  
  func cancelLoad() {
    delegate.didCancelImageRequest()
  }
}
