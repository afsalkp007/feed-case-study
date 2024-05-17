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
  
  func numberOfRows(in section: Int) -> Int {
    tableView.numberOfSections > section ? tableView.numberOfRows(inSection: section) : 0
  }
  
  func cell(row: Int, section: Int) -> UITableViewCell? {
    guard numberOfRows(in: section) > row else {
      return nil
    }
    let ds = tableView.dataSource
    let index = IndexPath(row: row, section: section)
    return ds?.tableView(tableView, cellForRowAt: index)
  }
}

extension ListViewController {
  func numberOfRenderedComments() -> Int {
    numberOfRows(in: commentsSection)
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
    cell(row: row, section: commentsSection) as? ImageCommentCell
  }
  
  var commentsSection: Int { 0 }
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
  
  func simulateTapOnFeedImage(at row: Int) {
    let delegate = tableView.delegate
    let index = IndexPath(row: row, section: feedImagesSection)
    delegate?.tableView?(tableView, didSelectRowAt: index)
  }
  
  func simulateFeedImageViewNotNearVisible(at row: Int) {
    simulateFeedImageViewNearVisible(at: row)
    
    let ds = tableView.prefetchDataSource
    let index = IndexPath(row: row, section: feedImagesSection)
    ds?.tableView?(tableView, cancelPrefetchingForRowsAt: [index])
  }
  
  func simulateLoadMoreFeedAction() {
    guard let view = loadMoreFeedCell() else { return }

    let delegate = tableView.delegate
    let index = IndexPath(row: 0, section: feedLoadMoreSection)
    delegate?.tableView?(tableView, willDisplay: view, forRowAt: index)
  }
  
  func simulateTapOnLoadMoreFeedError() {
    let delegate = tableView.delegate
    let index = IndexPath(row: 0, section: feedLoadMoreSection)
    delegate?.tableView?(tableView, didSelectRowAt: index)
  }
  
  var isShowingLoadMoreFeedIndicator: Bool {
      return loadMoreFeedCell()?.isLoading == true
  }
  
  var loadMoreFeedErrorMessage: String? {
    return loadMoreFeedCell()?.message
  }

  private func loadMoreFeedCell() -> LoadMoreCell? {
      cell(row: 0, section: feedLoadMoreSection) as? LoadMoreCell
  }
  
  func numberOfRenderedFeedImageViews() -> Int {
    numberOfRows(in: feedImagesSection)
  }
  
  private var feedImagesSection: Int { 0 }
  private var feedLoadMoreSection: Int { 1 }
  
  func feedImageView(at row: Int) -> UITableViewCell? {
    cell(row: row, section: feedImagesSection)
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
