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

func anyData() -> Data {
  return Data("any data".utf8)
}

func makeItemsJSON(_ items: [[String: Any]]) -> Data {
  let json = ["items": items]
  return try! JSONSerialization.data(withJSONObject: json)
}

extension HTTPURLResponse {
  convenience init(statusCode: Int) {
    self.init(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
  }
}

extension Date {
  func adding(seconds: TimeInterval) -> Date {
    return self + seconds
  }
  
  func adding(minutes: Int) -> Date {
    return Calendar(identifier: .gregorian).date(byAdding: .minute, value: minutes, to: self)!
  }
  
  func adding(days: Int) -> Date {
    return Calendar(identifier: .gregorian).date(byAdding: .day, value: days, to: self)!
  }
}


