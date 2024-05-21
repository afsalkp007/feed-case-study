//
//  FeedCache.swift
//  EssentialFeed
//
//  Created by Afsal on 28/04/2024.
//

import Foundation

public protocol FeedCache {  
  func save(_ feed: [FeedImage]) throws
}
