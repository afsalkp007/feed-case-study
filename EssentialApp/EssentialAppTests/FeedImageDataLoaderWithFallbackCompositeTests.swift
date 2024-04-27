//
//  FeedImageDataLoaderWithFallbackCompositeTests.swift
//  EssentialAppTests
//
//  Created by Afsal on 27/04/2024.
//

import XCTest
import EssentialFeed

class FeedImageDataLoaderWithFallbackComposite: FeedImageDataLoader {
  private class Task: FeedImageDataLoaderTask {
    func cancel() {}
  }
  
  init(primary: FeedImageDataLoader, fallback: FeedImageDataLoader) {
    
  }
  
  func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
    return Task()
  }
}

class FeedImageDataLoaderWithFallbackCompositeTests: XCTestCase {
  
  func test_init_doesNotLoadImageData() {
    let primaryLoader = LoaderSpy()
    let fallbackLoader = LoaderSpy()
    _ = FeedImageDataLoaderWithFallbackComposite(primary: primaryLoader, fallback: fallbackLoader)
    
    XCTAssertEqual(primaryLoader.loadedURLs, [], "Expected no loaded URLs in the primary loader")
    XCTAssertEqual(fallbackLoader.loadedURLs, [], "Expected no loaded URLs in the fallback loader")
  }
  
  // MARK: - Helpers
  
  private class LoaderSpy: FeedImageDataLoader {
    private var messages = [(url: URL, completion: (LocalFeedImageDataLoader.Result) -> Void)]()
    
    var loadedURLs: [URL] {
      return messages.map(\.url)
    }
    
    private struct Task: FeedImageDataLoaderTask {
      func cancel() {}
    }
    
    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
      messages.append((url, completion))
      return Task()
    }
  }
}
