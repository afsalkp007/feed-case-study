//
//  FeedCacheTestHelpers.swift
//  EssentialFeedTests
//
//  Created by Afsal on 21/03/2024.
//

import XCTest
import EssentialFeed

extension XCTestCase {
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
  func minusFeedCacheMaxAge() -> Date {
    return adding(days: -feedCacheMaxAgeInDays)
  }
  
  private var feedCacheMaxAgeInDays: Int {
    return 7
  }
}
