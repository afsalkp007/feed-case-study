//
//  Localized.swift
//  EssentialFeed
//
//  Created by Afsal on 22/04/2024.
//

import Foundation

public final class Localized {
  var bundle: Bundle {
    return Bundle(for: Localized.self)
  }
}

extension Localized {
  private static var feed: String { "Feed" }
  
  public enum Feed {
    public static var title: String {
      return NSLocalizedString(
        "FEED_VIEW_TITLE",
        tableName: feed,
        bundle: Bundle(for: FeedPresenter.self),
        comment: "Title for the feed view"
      )
    }
    
    public static var loadError: String {
      return NSLocalizedString(
        "FEED_VIEW_CONNECTION_ERROR",
        tableName: feed,
        bundle: Bundle(for: FeedPresenter.self),
        comment: "Error message for the feed error view"
      )
    }
  }
}
