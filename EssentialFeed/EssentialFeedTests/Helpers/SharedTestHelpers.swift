//
//  SharedTestHelpers.swift
//  EssentialFeedTests
//
//  Created by Afsal on 17/03/2024.
//

import XCTest
import EssentialFeed

func anyURL() -> URL {
  return URL(string: "http://any-url.com")!
}

func anyNSError() -> NSError {
  return NSError(domain: "any error", code: 0)
}
