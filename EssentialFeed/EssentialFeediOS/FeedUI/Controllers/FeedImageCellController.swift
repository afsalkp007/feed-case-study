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
  private var cell: FeedImageCell?
  
  init(delegate: FeedImageCellControllerDelegate) {
    self.delegate = delegate
  }
  
  func view(in tableView: UITableView) -> UITableViewCell {
    self.cell = tableView.dequeueReusableCell()
    delegate.didRequestImage()
    return cell!
  }
  
  func display(_ viewModel: FeedImageViewModel<UIImage>) {
    cell?.locationContainer.isHidden = !viewModel.hasLocation
    cell?.locationLabel.text = viewModel.location
    cell?.descriptionLabel.text = viewModel.description
    cell?.feedImageView.setImageAnimated(viewModel.image)
    cell?.feedImageContainer.isShimmering = viewModel.isLoading
    cell?.feedImageRetryButton.isHidden = !viewModel.shouldRetry
    
    cell?.onRetry = { [weak self] in
      self?.delegate.didRequestImage()
    }
    
    cell?.onReuse = { [weak self] in
      self?.releaseCellForReuse()
    }
  }
  
  func preload() {
    delegate.didRequestImage()
  }
  
  func cancelLoad() {
    releaseCellForReuse()
    delegate.didCancelImageRequest()
  }
  
  private func releaseCellForReuse() {
    cell?.onReuse = nil
    cell = nil
  }
}
