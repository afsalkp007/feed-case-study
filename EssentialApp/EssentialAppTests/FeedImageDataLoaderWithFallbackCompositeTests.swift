//
//  FeedImageDataLoaderWithFallbackCompositeTests.swift
//  EssentialAppTests
//
//  Created by Afsal on 27/04/2024.
//

import XCTest
import EssentialFeed

class FeedImageDataLoaderWithFallbackComposite: FeedImageDataLoader {
  private let primary: FeedImageDataLoader
  
  init(primary: FeedImageDataLoader, fallback: FeedImageDataLoader) {
    self.primary = primary
  }

  private class Task: FeedImageDataLoaderTask {
    func cancel() {}
  }
    
  func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
    _ = primary.loadImageData(from: url) { _ in }
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
  
  func test_loadImageDataFromURL_loadsFromPrimaryLoaderFirst() {
    let url = anyURL()
    let primaryLoader = LoaderSpy()
    let fallbackLoader = LoaderSpy()
    let sut = FeedImageDataLoaderWithFallbackComposite(primary: primaryLoader, fallback: fallbackLoader)
    
    _ = sut.loadImageData(from: url) { _ in }
    
    XCTAssertEqual(primaryLoader.loadedURLs, [url], "Expected to load URL from primary loader")
    XCTAssertTrue(fallbackLoader.loadedURLs.isEmpty, "Expected no loaded URLs in the fallback loader")
  }
  
  // MARK: - Helpers
  
  private func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
  }
  
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
