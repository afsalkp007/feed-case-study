//
//  FeedStoreSpy.swift
//  EssentialFeedTests
//
//  Created by Afsal on 19/03/2024.
//

import Foundation
import EssentialFeed

class FeedStoreSpy: FeedStore {
  enum RecievedMessage: Equatable {
    case deleteCachedFeed
    case insert([LocalFeedImage], Date)
    case retrieve
  }
  
  private(set) var receivedMessages = [RecievedMessage]()
  
  var deletionCompletions = [DeletionCompletion]()
  var insertionCompletions = [InsertionCompletion]()
  var retrievalCompletions = [RetrievalCompletion]()
  
  func deleteCachedFeed(completion: @escaping DeletionCompletion) {
    deletionCompletions.append(completion)
    receivedMessages.append(.deleteCachedFeed)
  }
  
  func completeDeletion(with error: Error, at index: Int = 0) {
    deletionCompletions[index](error)
  }
  
  func completeDeletionSuccessfully(at index: Int = 0) {
    deletionCompletions[index](nil)
  }
  
  func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
    receivedMessages.append(.insert(feed, timestamp))
    insertionCompletions.append(completion)
  }
  
  func completeInsertion(with error: Error, at index: Int = 0) {
    insertionCompletions[index](error)
  }
  
  func completeInsertionSuccessfully(at index: Int = 0) {
    insertionCompletions[index](nil)
  }
  
  func retrieve(completion: @escaping RetrievalCompletion) {
    retrievalCompletions.append(completion)
    receivedMessages.append(.retrieve)
  }
  
  func completeRetrieval(with error: Error, at index: Int = 0) {
    retrievalCompletions[index](error)
  }
}