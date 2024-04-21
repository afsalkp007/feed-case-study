//
//  FeedPresenterTests.swift
//  EssentialFeedTests
//
//  Created by Afsal on 21/04/2024.
//

import XCTest

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
  private let errorView: FeedErrorView

  init(errorView: FeedErrorView) {
    self.errorView = errorView
  }
  
  func didStartLoadingFeed() {
    errorView.display(.noError)
  }
}

class FeedPresenterTests: XCTestCase {
  
  func test_init_doesNotSendMessage() {
    let (_, view) = makeSUT()
    
    XCTAssertTrue(view.messages.isEmpty)
  }
  
  func test_didStartLoadingFeed_displaysNoError() {
    let (sut, view) = makeSUT()
    
    sut.didStartLoadingFeed()
    
    XCTAssertEqual(view.messages, [.display(.none)])
  }
  
  // MARK: - Helpers
  
  private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: FeedPresenter, view: ViewSpy) {
    let view = ViewSpy()
    let sut = FeedPresenter(errorView: view)
    trackForMemoryLeaks(view, file: file, line: line)
    trackForMemoryLeaks(sut, file: file, line: line)
    return (sut, view)
  }
  
  private final class ViewSpy: FeedErrorView {
    enum Message: Equatable {
      case display(String?)
    }
    
    var messages = [Message]()
    
    func display(_ viewModel: FeedErrorViewModel) {
      messages.append(.display(.none))
    }
  }
}
