//
//  FeedImagePresenterTests.swift
//  EssentialFeedTests
//
//  Created by Afsal on 22/04/2024.
//

import XCTest
import EssentialFeed

class FeedImagePresenterTests: XCTestCase {
  
  func test_init_doesNotSendMessageToView() {
    let (_, view) = makeSUT()
    
    XCTAssertTrue(view.messages.isEmpty)
  }
  
  func test_didStartLoadingWithImageData_displaysImageLoading() {
    let (sut, view) = makeSUT()
    let image = uniqueImage()
    
    sut.didStartLoadingWithImageData(for: image)

    let message = view.messages.first
    XCTAssertEqual(message?.description, image.description)
    XCTAssertEqual(message?.location, image.location)
    XCTAssertEqual(message?.isLoading, true)
    XCTAssertEqual(message?.shouldRetry, false)
    XCTAssertNil(message?.image)
  }
  
  func test_didFinishLoadingWithImageData_showsRetryOnImageTransformerFails() {
    let (sut, view) = makeSUT(imageTransformer: fail)
    let image = uniqueImage()

    sut.didFinishLoadingWithImageData(with: Data(), for: uniqueImage())
    
    let message = view.messages.first
    XCTAssertEqual(message?.description, image.description)
    XCTAssertEqual(message?.location, image.location)
    XCTAssertEqual(message?.isLoading, false)
    XCTAssertEqual(message?.shouldRetry, true)
    XCTAssertNil(message?.image)
  }
  
  func test_didFinishLoadingWithImageData_displaysImageOnImageTransformerSucceeds() {
    let image = uniqueImage()
    let tranformedData = AnyImage()
    let (sut, view) = makeSUT(imageTransformer: { _ in tranformedData })

    sut.didFinishLoadingWithImageData(with: Data(), for: image)
    
    let message = view.messages.first
    XCTAssertEqual(message?.description, image.description)
    XCTAssertEqual(message?.location, image.location)
    XCTAssertEqual(message?.isLoading, false)
    XCTAssertEqual(message?.shouldRetry, false)
    XCTAssertEqual(message?.image, tranformedData)
  }
  
  func test_didFinishLoadingWithImageDataWithError_displaysRetry() {
    let (sut, view) = makeSUT()
    let error = anyNSError()
    let image = uniqueImage()

    sut.didFinishLoadingWithImageData(with: error, for: image)
    
    let message = view.messages.first
    XCTAssertEqual(message?.description, image.description)
    XCTAssertEqual(message?.location, image.location)
    XCTAssertEqual(message?.isLoading, false)
    XCTAssertEqual(message?.shouldRetry, true)
    XCTAssertNil(message?.image)
  }
  
  // MARK: - Helpers
  
  private func makeSUT(
    imageTransformer: @escaping (Data) -> AnyImage? = { _ in nil },
    file: StaticString = #filePath,
    line: UInt = #line
  ) -> (sut: FeedImagePresenter<ViewSpy, AnyImage>, view: ViewSpy) {
    let view = ViewSpy()
    let sut = FeedImagePresenter<ViewSpy, AnyImage>(view: view, imageTransformer: imageTransformer)
    trackForMemoryLeaks(view, file: file, line: line)
    trackForMemoryLeaks(sut, file: file, line: line)
    return (sut, view)
  }
  
  private var fail: (Data) -> AnyImage? {
    return { _ in nil }
  }
  
  private struct AnyImage: Equatable {}
  
  private class ViewSpy: FeedImageView {
    private(set) var messages = [FeedImageViewModel<AnyImage>]()
    
    func display(_ viewModel: FeedImageViewModel<AnyImage>) {
      messages.append(viewModel)
    }
  }
}
