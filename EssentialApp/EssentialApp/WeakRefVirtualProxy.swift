//
//  WeakRefVirtualProxy.swift
//  EssentialFeediOS
//
//  Created by Afsal on 18/04/2024.
//

import UIKit
import EssentialFeed

final class WeakRefVirtualProxy<T: AnyObject> {
  private weak var object: T?
  
  init(_ object: T) {
    self.object = object
  }
}

extension WeakRefVirtualProxy: ResourceLoadingView where T: ResourceLoadingView {
  func display(_ viewModel: ResourceLoadingViewModel) {
    object?.display(viewModel)
  }
}

extension WeakRefVirtualProxy: ResourceErrorView where T: ResourceErrorView {
  func display(_ viewModel: ResourceErrorViewModel) {
    object?.display(viewModel)
  }
}

extension WeakRefVirtualProxy: ResourceView where T: ResourceView, T.ResourceViewModel == UIImage {
  func display(_ model: UIImage) {
    object?.display(model)
  }
}
