//
//  SharedTestHelpers.swift
//  EssentialFeedTests
//
//  Created by Afsal on 17/03/2024.
//

import XCTest
import EssentialFeed

extension XCTestCase {
  func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
  }
  
  func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
  }
  
  func uniqueImageFeed() -> (models: [FeedImage], local: [LocalFeedImage]) {
    let models = [uniqueImage(), uniqueImage()]
    let local = models.map { LocalFeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url) }
    return (models, local)
  }
  
  func uniqueImage() -> FeedImage {
    return FeedImage(id: UUID(), description: "description", location: "any", url: anyURL())
  }
}

extension Date {
  func adding(days: Int) -> Date {
    return Calendar(identifier: .gregorian).date(byAdding: .day, value: days, to: self)!
  }
  
  func adding(seconds: TimeInterval) -> Date {
    return self + seconds
  }
}

