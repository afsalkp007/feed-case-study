//
//  LocalizedTests.swift
//  EssentialFeedTests
//
//  Created by Afsal on 22/04/2024.
//

import XCTest
import EssentialFeed

final class Localized {
  var bundle: Bundle {
    return Bundle(for: Localized.self)
  }
}

extension Localized {
  private static var feed: String { "Feed" }
  
  enum Feed {
    static var title: String {
      return NSLocalizedString(
        "FEED_VIEW_TITLE",
        tableName: feed,
        bundle: Bundle(for: FeedPresenter.self),
        comment: "Title for the feed view"
      )
    }
  }
}

class LocalizedTests: XCTestCase {
  
  func test_Localized_title() {
    XCTAssertEqual(Localized.Feed.title, localized("FEED_VIEW_TITLE"))
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
