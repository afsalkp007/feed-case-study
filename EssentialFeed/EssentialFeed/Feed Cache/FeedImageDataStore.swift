//
//  FeedImageDataStore.swift
//  EssentialFeed
//
//  Created by Afsal on 24/04/2024.
//

import Foundation

public protocol FeedImageDataStore {
  func insert(_ data: Data, for url: URL) throws
  func retrieve(dataForURL url: URL) throws -> Data?
}
