//
//  LocalFeedImageDataLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Afsal on 23/04/2024.
//

import XCTest
import EssentialFeed

protocol FeedImageDataStore {
  func retrieve(dataForURL url: URL)
}

final class LocalFeedImageDataStore: FeedImageDataLoader {
  private struct Task: FeedImageDataLoaderTask {
    func cancel() {}
  }
  
  private let store: FeedImageDataStore
  
  init(store: FeedImageDataStore) {
    self.store = store
  }
  
  func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
    store.retrieve(dataForURL: url)
    return Task()
  }
}

class LocalFeedImageDataLoaderTests: XCTestCase {
  
  func test_init_doesNoSendMessageUponCreaion() {
    let (_, store) = makeSUT()
    
    XCTAssertTrue(store.receivedMessages.isEmpty)
  }
  
  func test_loadImageDataFromURL_requestsStoredDataForURL() {
    let (sut, store) = makeSUT()
    let url = anyURL()
    
    _ = sut.loadImageData(from: url) { _ in }
    
    XCTAssertEqual(store.receivedMessages, [.retrieve(dataFor: url)])
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
  
  private class FeedStoreSpy: FeedImageDataStore {
    enum Message: Equatable {
      case retrieve(dataFor: URL)
    }
    
    private(set) var receivedMessages = [Message]()
    
    func retrieve(dataForURL url: URL) {
      receivedMessages.append(.retrieve(dataFor: url))
    }
  }
}


