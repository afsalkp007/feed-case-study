//
//  FeedErrorViewModel.swift
//  EssentialFeed
//
//  Created by Afsal on 22/04/2024.
//

public struct FeedErrorViewModel {
  public let message: String?
  
  static var noError: FeedErrorViewModel {
    return FeedErrorViewModel(message: .none)
  }
  
  static func error(message: String) -> FeedErrorViewModel {
    return FeedErrorViewModel(message: message)
  }
}
