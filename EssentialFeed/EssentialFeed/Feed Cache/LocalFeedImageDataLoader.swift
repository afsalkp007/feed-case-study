//
//  LocalFeedImageDataLoader.swift
//  EssentialFeed
//
//  Created by Afsal on 24/04/2024.
//

import Foundation

public final class LocalFeedImageDataLoader {
  private let store: FeedImageDataStore
  
  public init(store: FeedImageDataStore) {
    self.store = store
  }
}

extension LocalFeedImageDataLoader: FeedImageDataCache {
  public enum SaveError: Swift.Error {
    case failed
  }
  
  public func save(_ data: Data, for url: URL) throws {
    do {
      try store.insert(data, for: url)
    } catch {
      throw SaveError.failed
    }
  }
}

extension LocalFeedImageDataLoader: FeedImageDataLoader {
  public enum LoadError: Swift.Error {
    case failed
    case notFound
  }
  
  public func loadImageData(from url: URL) throws -> Data {
    do {
      if let data = try store.retrieve(dataForURL: url) {
        return data
      }
    } catch {
      throw LoadError.failed
    }
    
    throw LoadError.notFound
  }
}
