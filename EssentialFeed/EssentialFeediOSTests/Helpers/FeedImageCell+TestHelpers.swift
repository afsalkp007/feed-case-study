//
//  FeedImageCell+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by Afsal on 06/04/2024.
//

import Foundation
import EssentialFeediOS

extension FeedImageCell {
  func simulateRetryAction() {
    feedImageRetryButton.simulateTap()
  }
  
  var isShowingLocation: Bool {
    return !locationContainer.isHidden
  }
  
  var isShowingImageLoadingIndicator: Bool {
    return feedImageContainer.isShimmering
  }
  
  var isShowingRetryAction: Bool {
    return !feedImageRetryButton.isHidden
  }
  
  var locationText: String? {
    return locationLabel.text
  }
  
  var descriptionText: String? {
    return descriptinoLabel.text
  }
  
  var renderedImage: Data? {
    return feedImageView.image?.pngData()
  }
}