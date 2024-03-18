//
//  LocalFeedLoader.swift
//  EssentialFeed
//
//  Created by Afsal on 18/03/2024.
//

import Foundation

public class LocalFeedLoader {
  private let store: FeedStore
  private let currentDate: () -> Date
  
  public init(store: FeedStore, currentDate: @escaping () -> Date) {
    self.store = store
    self.currentDate = currentDate
  }
  
  public func save(_ items: [FeedItem], completion: @escaping (Error?) -> Void) {
    store.deleteCachedFeed { [weak self] error in
      guard let self = self else { return }
      
      if let error = error {
        completion(error)
      } else {
        self.cache(items, completion: completion)
      }
    }
  }
  
  private func cache(_ items: [FeedItem], completion: @escaping (Error?) -> Void) {
    self.store.insert(items, timestamp: self.currentDate(), completion: { [weak self] error in
      guard self != nil else { return }
      completion(error)
    })
  }
}
