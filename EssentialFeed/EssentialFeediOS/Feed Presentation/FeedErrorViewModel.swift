//
//  FeedErrorViewModel.swift
//  EssentialFeediOS
//
//  Created by Afsal on 20/04/2024.
//

struct FeedErrorViewModel {
  let message: String?
  
  static var noError: FeedErrorViewModel {
    return FeedErrorViewModel(message: .none)
  }
  
  static func errorMessage(_ message: String) -> FeedErrorViewModel {
    return FeedErrorViewModel(message: message)
  }
}
