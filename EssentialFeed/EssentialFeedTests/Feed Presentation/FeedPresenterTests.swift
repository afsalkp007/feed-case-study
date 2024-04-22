//
//  FeedPresenterTests.swift
//  EssentialFeedTests
//
//  Created by Afsal on 21/04/2024.
//

import XCTest
import EssentialFeed

struct FeedLoadingViewModel {
  let isLoading: Bool
}

protocol FeedLoadingView {
  func display(_ viewModel: FeedLoadingViewModel)
}

struct FeedViewModel {
  let feed: [FeedImage]
}

protocol FeedView {
  func display(_ viewModel: FeedViewModel)
}

struct FeedErrorViewModel {
  let message: String?
  
  static var noError: FeedErrorViewModel {
    return FeedErrorViewModel(message: .none)
  }
  
  static func error(message: String) -> FeedErrorViewModel {
    return FeedErrorViewModel(message: message)
  }
}

protocol FeedErrorView {
  func display(_ viewModel: FeedErrorViewModel)
}

final class FeedPresenter {
  private let feedView: FeedView
  private let loadingView: FeedLoadingView
  private let errorView: FeedErrorView

  init(feedView: FeedView, loadingView: FeedLoadingView, errorView: FeedErrorView) {
    self.feedView = feedView
    self.loadingView = loadingView
    self.errorView = errorView
  }
  
  static var title: String {
    return NSLocalizedString(
      "FEED_VIEW_TITLE",
      tableName: "Feed",
      bundle: Bundle(for: FeedPresenter.self),
      comment: "Title for the feed view"
    )
  }
  
  private var loadError: String {
    return NSLocalizedString(
      "FEED_VIEW_CONNECTION_ERROR",
      tableName: "Feed",
      bundle: Bundle(for: FeedPresenter.self),
      comment: "Error message for the feed error view"
    )
  }
  
  func didStartLoadingFeed() {
    errorView.display(.noError)
    loadingView.display(FeedLoadingViewModel(isLoading: true))
  }
  
  func didFinishLoadingFeed(with feed: [FeedImage]) {
    feedView.display(FeedViewModel(feed: feed))  
    loadingView.display(FeedLoadingViewModel(isLoading: false))
  }
  
  func didFinishLoadingFeed(with error: Error) {
    loadingView.display(FeedLoadingViewModel(isLoading: false))
    errorView.display(.error(message: loadError))
  }
}

class FeedPresenterTests: XCTestCase {
  
  func test_title_isLocalized() {
    XCTAssertEqual(FeedPresenter.title, localized("FEED_VIEW_TITLE"), "Expected no view messages")
  }
  
  func test_init_doesNotSendMessage() {
    let (_, view) = makeSUT()
    
    XCTAssertTrue(view.messages.isEmpty)
  }
  
  func test_didStartLoadingFeed_displaysNoErrorAndDisplaysLoaoding() {
    let (sut, view) = makeSUT()
    
    sut.didStartLoadingFeed()
    
    XCTAssertEqual(view.messages, [
      .display(errorMessage: .none),
      .display(isLoading: true)])
  }
  
  func test_didFinishLoadingFeed_displaysFeedAndStopLoading() {
    let (sut, view) = makeSUT()
    let feed = uniqueImageFeed().models
    
    sut.didFinishLoadingFeed(with: feed)
    
    XCTAssertEqual(view.messages, [
      .display(feed: feed),
      .display(isLoading: false)])
  }
  
  func test_didFinishLoadingFeed_displaysErrorAndStopsLoading() {
    let (sut, view) = makeSUT()
    
    sut.didFinishLoadingFeed(with: anyNSError())
    
    XCTAssertEqual(view.messages, [.display(errorMessage: localized("FEED_VIEW_CONNECTION_ERROR")), .display(isLoading: false)])
  }
  
  // MARK: - Helpers
  
  private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: FeedPresenter, view: ViewSpy) {
    let view = ViewSpy()
    let sut = FeedPresenter(feedView: view, loadingView: view, errorView: view)
    trackForMemoryLeaks(view, file: file, line: line)
    trackForMemoryLeaks(sut, file: file, line: line)
    return (sut, view)
  }
  
  private func localized(_ key: String, file: StaticString = #filePath, line: UInt = #line) -> String {
    let table = "Feed"
    let bundle = Bundle(for: FeedPresenter.self)
    let value = bundle.localizedString(forKey: key, value: nil, table: table)
    if value == key {
      XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
    }
    return value
  }
  
  private final class ViewSpy: FeedView, FeedLoadingView, FeedErrorView {
    enum Message: Hashable {
      case display(errorMessage: String?)
      case display(isLoading: Bool)
      case display(feed: [FeedImage])
    }
    
    private(set) var messages = Set<Message>()
    
    func display(_ viewModel: FeedViewModel) {
      messages.insert(.display(feed: viewModel.feed))
    }
    
    func display(_ viewModel: FeedErrorViewModel) {
      messages.insert(.display(errorMessage: viewModel.message))
    }
    
    func display(_ viewModel: FeedLoadingViewModel) {
      messages.insert(.display(isLoading: viewModel.isLoading))
    }
  }
}
