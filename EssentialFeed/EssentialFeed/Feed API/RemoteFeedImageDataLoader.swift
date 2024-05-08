//
//  RemoteFeedImageDataLoader.swift
//  EssentialFeed
//
//  Created by Afsal on 23/04/2024.
//

import Foundation

public class RemoteFeedImageDataLoader: FeedImageDataLoader {
  private let client: HTTPClient
  
  public init(client: HTTPClient) {
    self.client = client
  }
  
  public enum Error: Swift.Error {
    case connectivity
    case invalidData
  }
  
  private final class HTTPClientTaskWrapper: FeedImageDataLoaderTask {
    private var completion: ((FeedImageDataLoader.Result) -> Void)?
    
    var wrapped: HTTPClientTask?
    
    init(_ completion: @escaping (FeedImageDataLoader.Result) -> Void) {
      self.completion = completion
    }
    
    func complete(with result: FeedImageDataLoader.Result) {
      completion?(result)
    }
    
    func cancel() {
      preventFurtherCompletions()
      wrapped?.cancel()
    }
    
    func preventFurtherCompletions() {
      completion = nil
    }
  }
  
  public func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
    let task = HTTPClientTaskWrapper(completion)
    task.wrapped = client.get(from: url) { [weak self] result in
      guard self != nil else { return }
      
      task.complete(with: result
        .mapError { _ in Error.connectivity }
        .flatMap(RemoteFeedImageDataLoader.map))
    }
    return task
  }
  
  private static func map(_ data: Data, from response: HTTPURLResponse) -> FeedImageDataLoader.Result {
    do {
      return .success(try FeedImageDataMapper.map(data, from: response))
    } catch {
      return .failure(error)
    }
  }
}
