//
//  FeedImagePresenterTests.swift
//  EssentialFeedTests
//
//  Created by Afsal on 22/04/2024.
//

import XCTest
import EssentialFeed

struct FeedImageViewModel {
  let description: String?
  let location: String?
  let image: Any?
  let isLoading: Bool
  let shouldRetry: Bool
  
  var hasLocation: Bool {
    return location != nil
  }
}

protocol FeedImageView {
  func display(_ viewModel: FeedImageViewModel)
}

final class FeedImagePresenter {
  private let view: FeedImageView
  
  init(view: FeedImageView) {
    self.view = view
  }
  
  func didStartLoadingWithImageData(for model: FeedImage) {
    view.display(FeedImageViewModel(
      description: model.description,
      location: model.location,
      image: nil,
      isLoading: true,
      shouldRetry: false))
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
  
  // MARK: - Helpers
  
  private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: FeedImagePresenter, view: ViewSpy) {
    let view = ViewSpy()
    let sut = FeedImagePresenter(view: view)
    trackForMemoryLeaks(view, file: file, line: line)
    trackForMemoryLeaks(sut, file: file, line: line)
    return (sut, view)
  }
  
  private class ViewSpy: FeedImageView {
    private(set) var messages = [FeedImageViewModel]()
    
    func display(_ viewModel: FeedImageViewModel) {
      messages.append(viewModel)
    }
  }
}
