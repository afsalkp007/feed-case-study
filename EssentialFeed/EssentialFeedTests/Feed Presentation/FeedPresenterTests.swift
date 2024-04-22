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

struct FeedErrorViewModel {
  let message: String?
  
  static var noError: FeedErrorViewModel {
    return FeedErrorViewModel(message: .none)
  }
}

protocol FeedErrorView {
  func display(_ viewModel: FeedErrorViewModel)
}

final class FeedPresenter {
  private let loadingView: FeedLoadingView
  private let errorView: FeedErrorView

  init(loadingView: FeedLoadingView, errorView: FeedErrorView) {
    self.loadingView = loadingView
    self.errorView = errorView
  }
  
  func didStartLoadingFeed() {
    errorView.display(.noError)
    loadingView.display(FeedLoadingViewModel(isLoading: true))
  }
}

class FeedPresenterTests: XCTestCase {
  
  func test_init_doesNotSendMessage() {
    let (_, view) = makeSUT()
    
    XCTAssertTrue(view.messages.isEmpty)
  }
  
  func test_didStartLoadingFeed_displaysNoErrorAndDisplaysLoaoding() {
    let (sut, view) = makeSUT()
    
    sut.didStartLoadingFeed()
    
    XCTAssertEqual(view.messages, [.display(.none), .isLoading(true)])
  }
  
  // MARK: - Helpers
  
  private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: FeedPresenter, view: ViewSpy) {
    let view = ViewSpy()
    let sut = FeedPresenter(loadingView: view, errorView: view)
    trackForMemoryLeaks(view, file: file, line: line)
    trackForMemoryLeaks(sut, file: file, line: line)
    return (sut, view)
  }
  
  private final class ViewSpy: FeedLoadingView, FeedErrorView {
    enum Message: Hashable {
      case display(String?)
      case isLoading(Bool)
    }
    
    var messages = Set<Message>()
    
    func display(_ viewModel: FeedErrorViewModel) {
      messages.insert(.display(.none))
    }
    
    func display(_ viewModel: FeedLoadingViewModel) {
      messages.insert(.isLoading(true))
    }
  }
}
