//
//  FeedImageViewModel.swift
//  EssentialFeed
//
//  Created by Afsal on 22/04/2024.
//

public struct FeedImageViewModel {
  public let description: String?
  public let location: String?
  
  public var hasLocation: Bool {
    return location != nil
  }
}
