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
    let view = ViewSpy()
    
    _ = FeedPresenter(view: view)
    
    XCTAssertTrue(view.messages.isEmpty)
  }
  
  // MARK: - Helpers
  
  private struct ViewSpy {
    let messages = [Any]()
  }
}
