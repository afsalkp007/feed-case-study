//
//  FeedCache.swift
//  EssentialFeed
//
//  Created by Afsal on 28/04/2024.
//

import Foundation

public protocol FeedCache {
  typealias Result = Swift.Result<Void, Error>
  
  func save(_ feed: [FeedImage], completion: @escaping (Result) -> Void)
}
