//
//  LocalizedTests.swift
//  EssentialFeedTests
//
//  Created by Afsal on 22/04/2024.
//

import XCTest
import EssentialFeed

class LocalizedTests: XCTestCase {
  
  func test_Localized_title() {
    XCTAssertEqual(Localized.Feed.title, localized("FEED_VIEW_TITLE"))
  }
  
  func test_Localized_loadError() {
    XCTAssertEqual(Localized.Feed.loadError, localized("FEED_VIEW_CONNECTION_ERROR"))
  }
  
  // MARK: - Helpers
  
  private func localized(_ key: String) -> String {
    let bundle = Bundle(for: FeedPresenter.self)
    let table = "Feed"
    let value = bundle.localizedString(forKey: key, value: nil, table: table)
    if value == key {
      XCTFail("Missing localized string for key: \(key) in table: \(table)")
    }
    return value
  }
}
