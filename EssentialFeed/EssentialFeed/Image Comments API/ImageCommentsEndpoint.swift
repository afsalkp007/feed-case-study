//
//  ImageCommentsEndPoint.swift
//  EssentialFeed
//
//  Created by Afsal on 14/05/2024.
//

import Foundation

public enum ImageCommentsEndpoint {
  case get(UUID)
  
  public func url(baseURL: URL) -> URL {
    switch self {
      
    case let .get(id):
      return baseURL.appendingPathComponent("/v1/image/\(id)/comments")
    }
  }
}
