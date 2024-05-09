//
//  ResourceErrorViewModel.swift
//  EssentialFeed
//
//  Created by Afsal on 22/04/2024.
//

public struct ResourceErrorViewModel {
  public let message: String?
  
  static var noError: ResourceErrorViewModel {
    return ResourceErrorViewModel(message: .none)
  }
  
  static func error(message: String) -> ResourceErrorViewModel {
    return ResourceErrorViewModel(message: message)
  }
}
