//
//  FeedImageCellController.swift
//  EssentialFeediOS
//
//  Created by Afsal on 06/04/2024.
//

import UIKit

final class FeedImageCellController {
  private var viewModel: FeedImageViewModel
  
  init(viewModel: FeedImageViewModel) {
    self.viewModel = viewModel
  }
  
  func view() -> UITableViewCell {
    return binded(FeedImageCell())
  }
  
  func binded(_ cell: FeedImageCell) -> FeedImageCell {
    cell.locationContainer.isHidden = !viewModel.hasLocation
    cell.locationLabel.text = viewModel.location
    cell.descriptinoLabel.text = viewModel.description
    
    viewModel.onImageLoad = { [weak cell] image in
      cell?.feedImageView.image = image
    }
    
    viewModel.onShouldRetryImageStateChange = { [weak cell] shouldRetry in
      cell?.feedImageRetryButton.isHidden = !shouldRetry
    }
    
    viewModel.onImageLoadingStateChange = { [weak cell] isLoading in
      cell?.feedImageContainer.isShimmering = isLoading
    }
    
    cell.onRetry = viewModel.loadImageData
    viewModel.loadImageData()
    
    return cell
  }
  
  func preload() {
    viewModel.loadImageData()
  }
  
  func cancelLoad() {
    viewModel.cancelImageDataLoad()
  }
}
