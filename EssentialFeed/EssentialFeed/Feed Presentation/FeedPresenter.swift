//
//  FeedPresenter.swift
//  EssentialFeed
//
//  Created by Afsal on 22/04/2024.
//

import Foundation

final public class FeedPresenter {
  public static var title: String {
    return NSLocalizedString(
      "FEED_VIEW_TITLE",
      tableName: "Feed",
      bundle: Bundle(for: FeedPresenter.self),
      comment: "Title for the feed view"
    )
  }
  
  public static func map(_ feed: [FeedImage]) -> FeedViewModel {
    FeedViewModel(feed: feed)
  }
 }
