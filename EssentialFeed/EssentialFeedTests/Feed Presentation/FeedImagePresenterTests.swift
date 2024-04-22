//
//  FeedImagePresenterTests.swift
//  EssentialFeedTests
//
//  Created by Afsal on 22/04/2024.
//

import XCTest

final class FeedImagePresenter {
  init(view: Any) {
    
  }
}

class FeedImagePresenterTests: XCTestCase {
  
  func test_init_doesNotSendMessageToView() {
    let view = ViewSpy()
    
    _ = FeedImagePresenter(view: view)
    
    XCTAssertTrue(view.messages.isEmpty)
  }
  
  // MARK: - Helpers
  
  private struct ViewSpy {
    let messages = [Any]()
  }
}
