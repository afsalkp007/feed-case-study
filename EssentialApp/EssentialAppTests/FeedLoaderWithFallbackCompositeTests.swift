//
//  EssentialAppTests.swift
//  EssentialAppTests
//
//  Created by Afsal on 27/04/2024.
//

import XCTest
import EssentialFeed

class FeedLoaderWithFallbackComposite: FeedLoader {
  private let primary: FeedLoader
  private let fallback: FeedLoader
  
  init(primary: FeedLoader, fallback: FeedLoader) {
    self.primary = primary
    self.fallback = fallback
  }
  
  func load(completion: @escaping (FeedLoader.Result) -> Void) {
    primary.load { [weak self] result in
      switch result {
      case let .success(feed):
        completion(.success(feed))
        
      case .failure:
        self?.fallback.load(completion: completion)
      }
    }
  }
}

class FeedLoaderWithFallbackCompositeTests: XCTestCase {
  
  func test_load_deliversPrimaryFeedOnPrimaryLoaderSuccess() {
    let primaryFeed = uniqueFeed()
    let fallbackFeed = uniqueFeed()
    let sut = makeSUT(primaryResult: .success(primaryFeed), fallbackResult: .success(fallbackFeed))
    
    expect(sut, toCompleteWith: primaryFeed)
  }
  
  func test_load_deliversFallbackFeedOnPrimaryLoaderFailure() {
    let primaryFeed = uniqueFeed()
    let fallbackFeed = uniqueFeed()
    let sut = makeSUT(primaryResult: .failure(anyNSError()), fallbackResult: .success(fallbackFeed))
    
    expect(sut, toCompleteWith: fallbackFeed)
  }
  
  // MARK: - Helpers
  
  private func makeSUT(primaryResult: FeedLoader.Result, fallbackResult: FeedLoader.Result, file: StaticString = #filePath, line: UInt = #line) -> FeedLoader {
    let primaryLoader = LoaderStub(result: primaryResult)
    let fallbackLoader = LoaderStub(result: fallbackResult)
    let sut = FeedLoaderWithFallbackComposite(primary: primaryLoader, fallback: fallbackLoader)
    trackForMemoryLeaks(primaryLoader, file: file, line: line)
    trackForMemoryLeaks(fallbackLoader, file: file, line: line)
    trackForMemoryLeaks(sut, file: file, line: line)
    return sut
  }
  
  private func expect(_ sut: FeedLoader, toCompleteWith expectedFeed: [FeedImage], file: StaticString = #filePath, line: UInt = #line) {
    let exp = expectation(description: "Wait for load completion")
    sut.load { result in
      switch result {
      case let .success(receivedFeed):
        XCTAssertEqual(receivedFeed, expectedFeed, file: file, line: line)

      case .failure:
        XCTFail("Expected successful load feed result, got \(result) instead", file: file, line: line)
      }
      exp.fulfill()
    }
    wait(for: [exp], timeout: 1.0)
  }
  
  private   func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
    addTeardownBlock { [weak instance] in
      XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
    }
  }
  
  private func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
  }
  
  private func uniqueFeed() -> [FeedImage] {
    return [FeedImage(id: UUID(), description: "any", location: "any", url: URL(string: "http://any-url.com")!)]
  }
  
  private class LoaderStub: FeedLoader {
    private let result: FeedLoader.Result
    
    init(result: FeedLoader.Result) {
      self.result = result
    }
    
    func load(completion: @escaping (FeedLoader.Result) -> Void) {
      completion(result)
    }
  }
}
