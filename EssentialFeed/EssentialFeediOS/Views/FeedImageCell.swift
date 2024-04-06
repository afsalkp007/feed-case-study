//
//  FeedImageCell.swift
//  EssentialFeediOS
//
//  Created by Afsal on 03/04/2024.
//

import UIKit

public final class FeedImageCell: UITableViewCell {
  public let locationContainer = UIView()
  public let locationLabel = UILabel()
  public let descriptinoLabel = UILabel()
  public let feedImageContainer = UIView()
  public let feedImageView = UIImageView()
  
  private(set) public lazy var feedImageRetryButton: UIButton = {
    let button = UIButton()
    button.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
    return button
  }()
  
  var onRetry: (() -> Void)?
  
  @objc private func retryButtonTapped() {
    onRetry?()
  }
}
