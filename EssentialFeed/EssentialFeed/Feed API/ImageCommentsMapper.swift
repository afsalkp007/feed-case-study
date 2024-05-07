//
//  ImageCommentsMapper.swift
//  EssentialFeed
//
//  Created by Afsal on 13/03/2024.
//

import Foundation

final class ImageCommentsMapper {
  private struct Root: Decodable {
    let items: [RemoteFeedItem]
  }

  private struct Item: Decodable {
    let id: UUID
    let description: String?
    let location: String?
    let image: URL
    
    var item: FeedImage {
      return FeedImage(id: id, description: description, location: location, url: image)
    }
  }
    
  static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemoteFeedItem] {
    guard response.isOK, let root = try? JSONDecoder().decode(Root.self, from: data) else {
      throw RemoteImageCommentsLoader.Error.invalidData
    }
    
    return root.items
  }
}
