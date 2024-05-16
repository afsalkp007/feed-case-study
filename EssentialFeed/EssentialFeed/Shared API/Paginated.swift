//
//  Paginated.swift
//  EssentialFeed
//
//  Created by Afsal on 16/05/2024.
//

import Combine

public struct Paginated<Item> {
  public typealias LoadMoreCompletion = (Result<Paginated<Item>, Error>) -> Void
  
  public let items: [Item]
  public let loadMore: ((@escaping LoadMoreCompletion) -> Void)?
  
  public init(items: [Item], loadMore: ((@escaping Paginated<Item>.LoadMoreCompletion) -> Void)? = nil) {
    self.items = items
    self.loadMore = loadMore
  }
}
