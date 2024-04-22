//
//  Localized.swift
//  EssentialFeediOS
//
//  Created by Afsal on 20/04/2024.
//

import Foundation
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
    
    static var loadError: String {
      return NSLocalizedString(
        "FEED_VIEW_CONNECTION_ERROR",
        tableName: feed,
        bundle: Bundle(for: FeedPresenter.self),
        comment: "Error message for the feed error view"
      )
    }
  }
}
