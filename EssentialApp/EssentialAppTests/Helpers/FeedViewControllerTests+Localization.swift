//
//  FeedViewControllerTests+Localization.swift
//  EssentialFeediOSTests
//
//  Created by Afsal on 18/04/2024.
//

import EssentialFeed

extension FeedUIIntegrationTests {
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
}
