//
//  FeedImageDataCache.swift
//  EssentialFeed
//
//  Created by Afsal on 28/04/2024.
//

import Foundation

public protocol FeedImageDataCache {
  func save(_ data: Data, for url: URL) throws
}
