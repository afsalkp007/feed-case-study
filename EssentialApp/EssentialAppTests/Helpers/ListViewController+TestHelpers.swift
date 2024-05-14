//
//  ListViewController+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by Afsal on 06/04/2024.
//

import Foundation
import UIKit
import EssentialFeediOS

extension ListViewController {
  func simulateUserInitiatedReload() {
    refreshControl?.simulatePullToRefresh()
  }
  
  var isShowingLoadingIndicator: Bool {
    return refreshControl?.isRefreshing == true
  }
  
  func simulateErrorViewTap() {
    errorView.simulateTap()
  }
  
  var errorMessage: String? {
    return errorView.message
  }
}

extension ListViewController {
  func numberOfRenderedComments() -> Int {
    return tableView.numberOfSections == 0 ? 0 : tableView.numberOfRows(inSection: commentsSection)
  }
  
  func commentMessage(at row: Int) -> String? {
    commentView(at: row)?.messageLabel.text
  }
  
  func commentDate(at row: Int) -> String? {
    commentView(at: row)?.dateLabel.text
  }
  
  func commentUsername(at row: Int) -> String? {
    commentView(at: row)?.usernameLabel.text
  }
  
  private func commentView(at row: Int) -> ImageCommentCell? {
    guard numberOfRenderedComments() > row else {
      return nil
    }
    let ds = tableView.dataSource
    let index = IndexPath(row: row, section: commentsSection)
    return ds?.tableView(tableView, cellForRowAt: index) as? ImageCommentCell
  }
  
  var commentsSection: Int {
    return 0
  }
}
 
extension ListViewController {
  @discardableResult
  func simulateFeedImageViewVisible(at index: Int) -> FeedImageCell? {
    return feedImageView(at: index) as? FeedImageCell
  }
  
  @discardableResult
  func simulateFeedImageViewNotVisible(at row: Int) -> FeedImageCell? {
    let view = simulateFeedImageViewVisible(at: row)
    
    let delegate = tableView.delegate
    let index = IndexPath(row: row, section: feedImagesSection)
    delegate?.tableView?(tableView, didEndDisplaying: view!, forRowAt: index)
    
    return view
  }
  
  func simulateFeedImageViewNearVisible(at row: Int) {
    let ds = tableView.prefetchDataSource
    let index = IndexPath(row: row, section: feedImagesSection)
    ds?.tableView(tableView, prefetchRowsAt: [index])
  }
  
  func renderedFeedImageData(at index: Int) -> Data? {
    return simulateFeedImageViewVisible(at: index)?.renderedImage
  }
  
  func simulateFeedImageViewNotNearVisible(at row: Int) {
    simulateFeedImageViewNearVisible(at: row)
    
    let ds = tableView.prefetchDataSource
    let index = IndexPath(row: row, section: feedImagesSection)
    ds?.tableView?(tableView, cancelPrefetchingForRowsAt: [index])
  }
  
  func numberOfRenderedFeedImageViews() -> Int {
    return tableView.numberOfSections == 0 ? 0 : tableView.numberOfRows(inSection: feedImagesSection)
  }
  
  var feedImagesSection: Int {
    return 0
  }
  
  func feedImageView(at row: Int) -> UITableViewCell? {
    guard numberOfRenderedFeedImageViews() > row else {
      return nil
    }
    let ds = tableView.dataSource
    let index = IndexPath(row: row, section: feedImagesSection)
    return ds?.tableView(tableView, cellForRowAt: index)
  }
}
 
extension ListViewController {
  func simulateAppearance() {
    if !isViewLoaded {
      loadViewIfNeeded()
      prepareForFirstAppearance()
    }
    beginAppearanceTransition(true, animated: false)
    endAppearanceTransition()
  }
  
  private func prepareForFirstAppearance() {
    setSmallFrameToPreventRenderingCells()
    replaceRefreshControlWithFakeForiOS17PlusSupport()
  }
  
  private func setSmallFrameToPreventRenderingCells() {
    tableView.frame = CGRect(x: 0, y: 0, width: 390, height: 1)
  }
  
  private func replaceRefreshControlWithFakeForiOS17PlusSupport() {
    let fakeRefreshControl = FakeUIRefreshControl()
    
    refreshControl?.allTargets.forEach { target in
      refreshControl?.actions(forTarget: target, forControlEvent: .valueChanged)?.forEach { action in
        fakeRefreshControl.addTarget(target, action: Selector(action), for: .valueChanged)
      }
    }
    
    refreshControl = fakeRefreshControl
  }
}

private class FakeUIRefreshControl: UIRefreshControl {
  var _isRefreshing: Bool = false
  
  override var isRefreshing: Bool { _isRefreshing }
  
  override func beginRefreshing() {
    _isRefreshing = true
  }
  
  override func endRefreshing() {
    _isRefreshing = false
  }
}
