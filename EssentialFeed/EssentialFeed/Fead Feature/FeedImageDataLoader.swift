//
//  FeedImageDataLoader.swift
//  EssentialFeediOS
//
//  Created by Afsal on 06/04/2024.
//

import Foundation

public protocol FeedImageDataLoader {
  func loadImageData(from url: URL) throws -> Data
}
