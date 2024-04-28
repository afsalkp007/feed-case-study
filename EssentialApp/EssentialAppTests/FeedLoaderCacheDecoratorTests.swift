//
//  FeedLoaderCacheDecoratorTests.swift
//  EssentialAppTests
//
//  Created by Afsal on 28/04/2024.
//

import XCTest
import EssentialFeed

class FeedLoaderCacheDecorator: FeedLoader {
  private let decoratee: FeedLoader
  
  init(decoratee: FeedLoader) {
    self.decoratee = decoratee
  }
  
  func load(completion: @escaping (FeedLoader.Result) -> Void) {
    decoratee.load(completion: completion)
  }
}

class FeedLoaderCacheDecoratorTests: XCTestCase, FeedLoaderTestCase {
  
  func test_load_deliversFeedOnLoaderSuccess() {
    let feed = uniqueFeed()
    let loader = FeedLoaderStub(result: .success(feed))
    let sut = FeedLoaderCacheDecorator(decoratee: loader)
    
    expect(sut, toCompleteWith: .success(feed))
  }
  
  func test_load_deliversFailureOnLoaderFailure() {
    let loader = FeedLoaderStub(result: .failure(anyNSError()))
    let sut = FeedLoaderCacheDecorator(decoratee: loader)
    
    expect(sut, toCompleteWith: .failure(anyNSError()))
  }
}
