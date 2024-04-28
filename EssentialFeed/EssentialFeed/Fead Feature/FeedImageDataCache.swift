//
//  FeedImageDataCache.swift
//  EssentialFeed
//
//  Created by Afsal on 28/04/2024.
//

import Foundation

public protocol FeedImageDataCache {
  typealias Result = Swift.Result<Void, Swift.Error>

  func save(_ data: Data, for url: URL, completion: @escaping (Result) -> Void)
}
