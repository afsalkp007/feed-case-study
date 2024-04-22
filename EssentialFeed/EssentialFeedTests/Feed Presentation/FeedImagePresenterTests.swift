//
//  FeedImagePresenterTests.swift
//  EssentialFeedTests
//
//  Created by Afsal on 22/04/2024.
//

import XCTest
import EssentialFeed

struct FeedImageViewModel<Image> {
  let description: String?
  let location: String?
  let image: Image?
  let isLoading: Bool
  let shouldRetry: Bool
  
  var hasLocation: Bool {
    return location != nil
  }
}

protocol FeedImageView {
  associatedtype Image
  
  func display(_ viewModel: FeedImageViewModel<Image>)
}

final class FeedImagePresenter<View: FeedImageView, Image> where View.Image == Image {
  private let view: View
  private let imageTransformer: (Data) -> Image?
  
  init(view: View, imageTransformer: @escaping (Data) -> Image?) {
    self.view = view
    self.imageTransformer = imageTransformer
  }
  
  func didStartLoadingWithImageData(for model: FeedImage) {
    view.display(FeedImageViewModel(
      description: model.description,
      location: model.location,
      image: nil,
      isLoading: true,
      shouldRetry: false))
  }
  
  func didFinishLoadingWithImageData(with data: Data, for model: FeedImage) {
    let image = imageTransformer(data)
    
    view.display(FeedImageViewModel(
      description: model.description,
      location: model.location,
      image: image,
      isLoading: false,
      shouldRetry: image == nil))
  }
  
  func didFinishLoadingWithImageData(with error: Error, for model: FeedImage) {
    view.display(FeedImageViewModel(
      description: model.description,
      location: model.location,
      image: nil,
      isLoading: false,
      shouldRetry: true))
  }
}

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
    let data = anyData()
    let image = uniqueImage()

    sut.didFinishLoadingWithImageData(with: data, for: image)
    
    let message = view.messages.first
    XCTAssertEqual(message?.description, image.description)
    XCTAssertEqual(message?.location, image.location)
    XCTAssertEqual(message?.isLoading, false)
    XCTAssertEqual(message?.shouldRetry, true)
    XCTAssertNil(message?.image)
  }
  
  func test_didFinishLoadingWithImageData_displaysImageOnImageTransformerSucceeds() {
    let data = anyData()
    let image = uniqueImage()
    let tranformedData = AnyImage()
    let (sut, view) = makeSUT(imageTransformer: { _ in tranformedData })

    sut.didFinishLoadingWithImageData(with: data, for: image)
    
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
