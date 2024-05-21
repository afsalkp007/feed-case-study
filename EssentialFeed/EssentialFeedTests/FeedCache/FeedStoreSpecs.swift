//
//  FeedStoreSpecs.swift
//  EssentialFeedTests
//
//  Created by Afsal on 27/03/2024.
//

import Foundation

protocol FeedStoreSpecs {
  func test_retrieve_deliversEmptyOnEmptyCache() throws
  func test_retrieve_hasNoSideEffectsOnEmptyCache() throws
  func test_retrieve_deliversFoundValuesOnNonEmptyCache() throws
  func test_retrieve_hasNoSideEffectsOnNonEmptyCache() throws

  func test_insert_deliversNoErrorOnEmptyCache() throws
  func test_insert_deliversNoErrorOnNonEmptyCache() throws
  func test_insert_overridesPreviouslyInsertedCacheValues() throws

  func test_delete_deliversNoErrorOnEmptyCache() throws
  func test_delete_hasNoSideEffectsOnEmptyCache() throws
  func test_delete_deliversNoErrorOnNonEmptyCache() throws
  func test_delete_emptiesPreviouslyInsertedCache() throws
}

protocol FailableRetrieveFeedStoreSpecs: FeedStoreSpecs {
  func test_retrieve_deliversFailureOnRetrievalError() throws
  func test_retrieve_hasNoSideEffectsOnFailure() throws
}

protocol FailableInsertFeedStoreSpecs: FeedStoreSpecs {
  func test_insert_deliversErrorOnInsertionError() throws
  func test_insert_hasNoSideEffectsOnInsertionError() throws
}

protocol FailableDeleteFeedStoreSpecs: FeedStoreSpecs {
  func test_delete_deliversErrorOnDeletionError() throws
  func test_delete_hasNoSideEffectsOnDeletionError() throws
}

typealias FailableFeedStore = FailableRetrieveFeedStoreSpecs & FailableInsertFeedStoreSpecs & FailableDeleteFeedStoreSpecs
