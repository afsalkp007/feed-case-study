//
//  RemoteFeedImageDataLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Afsal on 23/04/2024.
//

import XCTest

class RemoteFeedImageDataLoader {
  init(client: Any) {
    
  }
}

class RemoteFeedImageDataLoaderTests: XCTestCase {
  
  func test_init_doesNotPerformAnyURLRequest() {
    let client = HTTPClientSpy()
    
    _ = RemoteFeedImageDataLoader(client: client)
    
    XCTAssertTrue(client.requestedURLs.isEmpty)
  }
  
  // MARK: - Helpers
  
  private class HTTPClientSpy {
    var requestedURLs = [URL]()
  }
}
