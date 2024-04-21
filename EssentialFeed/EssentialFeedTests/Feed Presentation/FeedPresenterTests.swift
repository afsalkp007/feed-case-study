//
//  FeedPresenterTests.swift
//  EssentialFeedTests
//
//  Created by Afsal on 21/04/2024.
//

import XCTest

final class FeedPresenter {
  init(view: Any) {
    
  }
}

class FeedPresenterTests: XCTestCase {
  
  func test_init_doesNotSendMessage() {
    let (_, view) = makeSUT()
    
    XCTAssertTrue(view.messages.isEmpty)
  }
  
  // MARK: - Helpers
  
  private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: FeedPresenter, view: ViewSpy) {
    let view = ViewSpy()
    let sut = FeedPresenter(view: view)
    trackForMemoryLeaks(view, file: file, line: line)
    trackForMemoryLeaks(sut, file: file, line: line)
    return (sut, view)
  }
  
  private class ViewSpy {
    let messages = [Any]()
  }
}
