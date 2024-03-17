//
//  CacheFeedUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Afsal on 17/03/2024.
//

import XCTest
import EssentialFeed

class LocalFeedLoader {
  private let currentDate: () -> Date
  private let store: FeedStore
  
  init(currentDate: @escaping () -> Date, store: FeedStore) {
    self.currentDate = currentDate
    self.store = store
  }
  
  func save(_ items: [FeedItem]) {
    store.deleteCachedFeed { [unowned self] error in
      if error == nil {
        self.store.insert(items, timestamp: self.currentDate())
      }
    }
  }
}

class FeedStore {
  typealias DeletionCompletion = (Error?) -> Void
  
  var deleteCachedFeedCallCount = 0
  var insertCallCount = 0
  var insertions = [(items: [FeedItem], timestamp: Date)]()
  
  var deletionCompletions = [DeletionCompletion]()
  
  func deleteCachedFeed(completion: @escaping DeletionCompletion) {
    deleteCachedFeedCallCount += 1
    deletionCompletions.append(completion)
  }
  
  func completeDeletion(with error: Error, at index: Int = 0) {
    deletionCompletions[index](error)
  }
  
  func completeDeletionSuccessfully(at index: Int = 0) {
    deletionCompletions[index](nil)
  }
  
  func insert(_ items: [FeedItem], timestamp: Date) {
    insertCallCount += 1
    insertions.append((items, timestamp))
  }
}

class CacheFeedUseCaseTests: XCTestCase {
  
  func test_init_doesNotDeleteCacheUponCreation() {
    let (_, store)  = makeSUT()
    
    XCTAssertEqual(store.deleteCachedFeedCallCount, 0)
  }
  
  func test_save_requestsCacheDeletion() {
    let items = [uniqueItem(), uniqueItem()]
    let (sut, store) = makeSUT()

    sut.save(items)
    
    XCTAssertEqual(store.deleteCachedFeedCallCount, 1)
  }
  
  func test_save_doesNotRequestCacheInsertionOnDeletionError() {
    let items = [uniqueItem(), uniqueItem()]
    let (sut, store)  = makeSUT()
    let deletionError = anyNSError()

    sut.save(items)
    store.completeDeletion(with: deletionError)
    
    XCTAssertEqual(store.insertions.count, 0)
  }
  
  func test_save_requestsNewCacheInsertionOnSuccessfulDeletion() {
    let timestamp = Date()
    let items = [uniqueItem(), uniqueItem()]
    let (sut, store)  = makeSUT()

    sut.save(items)
    store.completeDeletionSuccessfully()
    
    XCTAssertEqual(store.insertions.count, 1)
  }
  
  func test_save_requestsNewCacheInsertionWithTimestampOnSuccessfulDeletion() {
    let timestamp = Date()
    let items = [uniqueItem(), uniqueItem()]
    let (sut, store)  = makeSUT(currentData: { timestamp })

    sut.save(items)
    store.completeDeletionSuccessfully()
    
    XCTAssertEqual(store.insertCallCount, 1)
    XCTAssertEqual(store.insertions.first?.items, items)
    XCTAssertEqual(store.insertions.first?.timestamp, timestamp)
  }
  
  // MARK: - Helpers
  
  func makeSUT(currentData: @escaping () -> Date = Date.init, file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStore) {
    let store  = FeedStore()
    let sut = LocalFeedLoader(currentDate: currentData, store: store)
    trackForMemoryLeaks(sut, file: file, line: line)
    trackForMemoryLeaks(store, file: file, line: line)
    return (sut, store)
  }
  
  func uniqueItem() -> FeedItem {
    return FeedItem(id: UUID(), description: "description", location: "any", imageURL: anyURL())
  }
}
