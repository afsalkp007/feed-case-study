//
//  FeedImageDataMapper.swift
//  EssentialFeed
//
//  Created by Afsal on 08/05/2024.
//

import Foundation

public final class FeedImageDataMapper {
  private enum Error: Swift.Error {
    case invalidData
  }
  
  public static func map(_ data: Data, from response: HTTPURLResponse) throws -> Data {
    guard response.isOK && !data.isEmpty else {
      throw Error.invalidData
    }
    
    return data
  }
}
