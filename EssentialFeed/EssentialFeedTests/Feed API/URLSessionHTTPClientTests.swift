//
//  URLSessionHTTPClientTests.swift
//  EssentialFeedTests
//
//  Created by Afsal on 13/03/2024.
//

import XCTest
import EssentialFeed

final class URLSessionHTTPClientTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    URLProtocolStub.startInterceptingRequests()
  }
  
  override func tearDown() {
    super.tearDown()
    URLProtocolStub.stopInterceptingRequests()
  }
  
  func test_getFromURL_performGETRequestWithURL() {
    let url = anyURL()
    let exp = expectation(description: "Wait for request")
    
    URLProtocolStub.observeRequests { request in
      XCTAssertEqual(request.url, url)
      XCTAssertEqual(request.httpMethod, "GET")
      exp.fulfill()
    }
    
    makeSUT().get(from: url) { _ in }
    
    wait(for: [exp], timeout: 1.0)
  }
  
  func test_getFromURL_failsOnRequestError() {
    let requestError = anyNSError()
    
    let receivedError = resultErrorFor(data: nil, response: nil, error: requestError) as? NSError
    
    XCTAssertEqual(receivedError?.code, requestError.code)
    XCTAssertEqual(receivedError?.domain, requestError.domain)
  }
  
  func test_getFromURL_failsOnAllNilValues() {
    XCTAssertNotNil(resultErrorFor(data: nil, response: nil, error: nil))
  }
  
  func test_getFromURL_failsOnAllInvalidRepresentationCases() {
    XCTAssertNotNil(resultErrorFor(data: nil, response: nonHTTPURLResponse(), error: nil))
    XCTAssertNotNil(resultErrorFor(data: anyData(), response: nil, error: nil))
    XCTAssertNotNil(resultErrorFor(data: anyData(), response: nil, error: anyNSError()))
    XCTAssertNotNil(resultErrorFor(data: nil, response: nonHTTPURLResponse(), error: anyNSError()))
    XCTAssertNotNil(resultErrorFor(data: nil, response: anyHTTPURLResponse(), error: anyNSError()))
    XCTAssertNotNil(resultErrorFor(data: anyData(), response: nonHTTPURLResponse(), error: anyNSError()))
    XCTAssertNotNil(resultErrorFor(data: anyData(), response: anyHTTPURLResponse(), error: anyNSError()))
    XCTAssertNotNil(resultErrorFor(data: anyData(), response: nonHTTPURLResponse(), error: nil))
  }
  
  func test_getFromURL_succeedsOnHTTPURLResponseWithData() {
    let data = anyData()
    let response = anyHTTPURLResponse()
    
    let receivedValues = resultValuesFor(data: data, response: response, error: nil)
    
    XCTAssertEqual(receivedValues?.data, data)
    XCTAssertEqual(receivedValues?.response.url, response.url)
    XCTAssertEqual(receivedValues?.response.statusCode, response.statusCode)
  }
  
  func test_getFromURL_succeedsWithEmptyDataOnHTTPURLResponseWithNilData() {
    let response = anyHTTPURLResponse()
    
    let receivedValues = resultValuesFor(data: nil, response: response, error: nil)
    
    let emptyData = Data()
    XCTAssertEqual(receivedValues?.data, emptyData)
    XCTAssertEqual(receivedValues?.response.url, response.url)
    XCTAssertEqual(receivedValues?.response.statusCode, response.statusCode)
  }
  
  func test_cancelGetFromURLTask_cancelsURLRequest() {
    let url = anyURL()
    let exp = expectation(description: "Wait for request")
    
    let task = makeSUT().get(from: url) { result in
      switch result {
      case let .failure(error as NSError) where error.code == URLError.cancelled.rawValue:
        break
        
      default:
        XCTFail("Expected cancelled result, got \(result) instead")
      }
      exp.fulfill()
    }
    
    task.cancel()
    wait(for: [exp], timeout: 1.0)
  }
  
  // MARK: - Helpers
  
  private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> HTTPClient {
    let sut = URLSessionHTTPClient()
    trackForMemoryLeaks(sut, file: file, line: line)
    return sut
  }
  
  private func resultFor(data: Data?, response: URLResponse?, error: Error?, file: StaticString = #filePath, line: UInt = #line) -> HTTPClient.Result {
    let sut = makeSUT(file: file, line: line)
    URLProtocolStub.stub(data: data, response: response, error: error)
    let exp = expectation(description: "Wait for completion")

    var receivedResult: HTTPClient.Result!
    sut.get(from: anyURL()) { result in
      receivedResult = result
      exp.fulfill()
    }

    wait(for: [exp], timeout: 1.0)
    return receivedResult
  }
  
  private func resultValuesFor(data: Data?, response: URLResponse?, error: Error?, file: StaticString = #filePath, line: UInt = #line) -> (data: Data, response: HTTPURLResponse)? {
    let result = resultFor(data: data, response: response, error: error)
    switch result {
    case let .success((data, response)):
      return (data, response)
    default:
      XCTFail("Expected success, got \(result) instead", file: file, line: line)
      return nil
    }
  }
  
  private func resultErrorFor(data: Data?, response: URLResponse?, error: Error?, file: StaticString = #filePath, line: UInt = #line) -> Error? {
    let result = resultFor(data: data, response: response, error: error)
    switch result {
    case let .failure(error):
      return error
      
    default:
      XCTFail("Expected failure, got \(result) instead", file: file, line: line)
      return nil
    }
  }
    
  private func anyHTTPURLResponse() -> HTTPURLResponse {
    return HTTPURLResponse(url: anyURL(), statusCode: 200, httpVersion: nil, headerFields: nil)!
  }

  private func nonHTTPURLResponse() -> URLResponse {
    return URLResponse(url: anyURL(), mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
  }
  
  private class URLProtocolStub: URLProtocol {
    private static var requestObserver: ((URLRequest) -> Void)?
    
    private struct Stub {
      let data: Data?
      let response: URLResponse?
      let error: Error?
      let requestObserver: ((URLRequest) -> Void)?
    }
    
    private static var _stub: Stub?
    private static var stub: Stub? {
      get { return queue.sync { _stub } }
      set { queue.sync { _stub = newValue } }
    }
    
    private static let queue = DispatchQueue(label: "URLProtocolStub.queue")

    static func stub(data: Data?, response: URLResponse?, error: Error?) {
      stub = Stub(data: data, response: response, error: error, requestObserver: nil)
    }
    
    static func observeRequests(observer: @escaping (URLRequest) -> Void) {
      stub = Stub(data: nil, response: nil, error: nil, requestObserver: observer)
    }
    
    static func startInterceptingRequests() {
      URLProtocol.registerClass(URLProtocolStub.self)
    }

    static func stopInterceptingRequests() {
      URLProtocol.unregisterClass(URLProtocolStub.self)
      stub = nil
    }

    override class func canInit(with request: URLRequest) -> Bool {
      return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
      return request
    }
    
    override func startLoading() {
      guard let stub = URLProtocolStub.stub else { return }
      
      if let data = stub.data {
        client?.urlProtocol(self, didLoad: data)
      }
      
      if let response = stub.response {
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
      }

      if let error = stub.error {
        client?.urlProtocol(self, didFailWithError: error)
      } else {
        client?.urlProtocolDidFinishLoading(self)
      }
      
      stub.requestObserver?(request)
    }

    override func stopLoading() {}
  }
}
