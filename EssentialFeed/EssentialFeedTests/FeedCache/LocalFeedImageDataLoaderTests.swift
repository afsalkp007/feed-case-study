//
//  LocalFeedImageDataLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Afsal on 23/04/2024.
//

import XCTest

final class LocalFeedImageDataStore {
  init(store: Any) {
    
  }
}

class LocalFeedImageDataLoaderTests: XCTestCase {
  
  func test_init_doesNoSendMessageUponCreaion() {
    let (_, store) = makeSUT()
    
    XCTAssertTrue(store.receivedMessages.isEmpty)
  }
  
  // MARK: - Helpers
  
  private func makeSUT(
    file: StaticString = #filePath,
    line: UInt = #line
  ) -> (
    sut: LocalFeedImageDataStore,
    store: FeedStoreSpy
  ) {
    let store = FeedStoreSpy()
    let sut = LocalFeedImageDataStore(store: store)
    trackForMemoryLeaks(store, file: file, line: line)
    trackForMemoryLeaks(sut, file: file, line: line)
    return (sut, store)
  }
  
  private class FeedStoreSpy {
    let receivedMessages = [Any]()
  }
}


