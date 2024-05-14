//
//  FeedEndPoint.swift
//  EssentialFeed
//
//  Created by Afsal on 14/05/2024.
//

import Foundation

public enum FeedEndpoint {
  case get
  
  public func url(baseURL: URL) -> URL {
    return baseURL.appendingPathComponent("/v1/feed")
  }
}
