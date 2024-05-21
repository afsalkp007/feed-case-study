//
//  SharedTestHelpers.swift
//  EssentialAppTests
//
//  Created by Afsal on 27/04/2024.
//

import Foundation
import EssentialFeed

func anyData() -> Data {
  return Data("any data".utf8)
}

func anyURL() -> URL {
  return URL(string: "http://any-url.com")!
}

func anyNSError() -> NSError {
  return NSError(domain: "any error", code: 0)
}

func uniqueFeed() -> [FeedImage] {
  return [FeedImage(id: UUID(), description: "any", location: "any", url: anyURL())]
}

private class DummyView: ResourceView {
  func display(_ viewModel: Any) {}
}

var loadError: String {
  LoadResourcePresenter<Any, DummyView>.loadError
}

var feedTitle: String {
  FeedPresenter.title
}

var commentsTitle: String {
  ImageCommentsPresenter.title
}


