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
  
  func save(_ items: [FeedItem], completion: @escaping (Error?) -> Void) {
    store.deleteCachedFeed { [unowned self] error in
      if error == nil {
        self.store.insert(items, timestamp: self.currentDate(), completion: completion)
      } else {
        completion(error)
      }
    }
  }
}

class FeedStore {
  typealias DeletionCompletion = (Error?) -> Void
  typealias InsertionCompletion = (Error?) -> Void
  
  var deletionCompletions = [DeletionCompletion]()
  var insertionCompletions = [InsertionCompletion]()
  
  enum RecievedMessage: Equatable {
    case deleteCachedFeed
    case insert([FeedItem], Date)
  }
  
  private(set) var receivedMessages = [RecievedMessage]()
  
  func deleteCachedFeed(completion: @escaping DeletionCompletion) {
    deletionCompletions.append(completion)
    receivedMessages.append(.deleteCachedFeed)
  }
  
  func completeDeletion(with error: Error, at index: Int = 0) {
    deletionCompletions[index](error)
  }
  
  func completeDeletionSuccessfully(at index: Int = 0) {
    deletionCompletions[index](nil)
  }
  
  func insert(_ items: [FeedItem], timestamp: Date, completion: @escaping InsertionCompletion) {
    receivedMessages.append(.insert(items, timestamp))
    insertionCompletions.append(completion)
  }
  
  func completeInsertion(with error: Error, at index: Int = 0) {
    insertionCompletions[index](error)
  }
  
  func completeInsertionSuccessfully(at index: Int = 0) {
    insertionCompletions[index](nil)
  }
}

class CacheFeedUseCaseTests: XCTestCase {
  
  func test_init_doesNotMessageCacheUponCreation() {
    let (_, store)  = makeSUT()
    
    XCTAssertEqual(store.receivedMessages, [])
  }
  
  func test_save_requestsCacheDeletion() {
    let items = [uniqueItem(), uniqueItem()]
    let (sut, store) = makeSUT()

    sut.save(items) { _ in }
    
    XCTAssertEqual(store.receivedMessages, [.deleteCachedFeed])
  }
  
  func test_save_doesNotRequestCacheInsertionOnDeletionError() {
    let items = [uniqueItem(), uniqueItem()]
    let (sut, store)  = makeSUT()
    let deletionError = anyNSError()

    sut.save(items) { _ in }
    store.completeDeletion(with: deletionError)
    
    XCTAssertEqual(store.receivedMessages, [.deleteCachedFeed])
  }
  
  func test_save_requestsNewCacheInsertionWithTimestampOnSuccessfulDeletion() {
    let timestamp = Date()
    let items = [uniqueItem(), uniqueItem()]
    let (sut, store)  = makeSUT(currentData: { timestamp })

    sut.save(items) { _ in }
    store.completeDeletionSuccessfully()
    
    XCTAssertEqual(store.receivedMessages, [.deleteCachedFeed, .insert(items, timestamp)])
  }
  
  func test_save_failsOnDeletionError() {
    let items = [uniqueItem(), uniqueItem()]
    let (sut, store)  = makeSUT()
    let deletionError = anyNSError()

    var receivedError: Error?
    sut.save(items) { error in
      receivedError = error
    }
    store.completeDeletion(with: deletionError)

    XCTAssertEqual(receivedError as NSError?, deletionError)
  }
  
  func test_save_failsOnInsertionError() {
    let items = [uniqueItem(), uniqueItem()]
    let (sut, store)  = makeSUT()
    let insertionError = anyNSError()

    var receivedError: Error?
    sut.save(items) { error in
      receivedError = error
    }
    store.completeDeletionSuccessfully()
    store.completeInsertion(with: insertionError)

    XCTAssertEqual(receivedError as NSError?, insertionError)
  }
  
  func test_save_succeedsOnSuccessfulCacheInsertion() {
    let items = [uniqueItem(), uniqueItem()]
    let (sut, store)  = makeSUT()

    var receivedError: Error?
    sut.save(items) { error in
      receivedError = error
    }
    store.completeDeletionSuccessfully()
    store.completeInsertionSuccessfully()

    XCTAssertNil(receivedError)
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
