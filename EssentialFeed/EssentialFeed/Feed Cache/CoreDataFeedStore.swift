//
//  CoreDataFeedStore.swift
//  EssentialFeed
//
//  Created by Afsal on 27/03/2024.
//

import Foundation

public class CoreDataFeedStore: FeedStore {
  public init() {}
  
  public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
  
  }
  
  public func insert(_ feed: [EssentialFeed.LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
    
  }
  
  public func retrieve(completion: @escaping RetrievalCompletion) {
    completion(.empty)
  }
}
