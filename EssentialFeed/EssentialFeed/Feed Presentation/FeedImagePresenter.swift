//
//  FeedImagePresenter.swift
//  EssentialFeed
//
//  Created by Afsal on 22/04/2024.
//

import Foundation

public final class FeedImagePresenter {
  
  public static func map(_ image: FeedImage) -> FeedImageViewModel {
    FeedImageViewModel(
      description: image.description,
      location: image.location)
  }
}
