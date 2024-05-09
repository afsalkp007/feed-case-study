//
//  ImageCommentsPresenter.swift
//  EssentialFeed
//
//  Created by Afsal on 09/05/2024.
//

import Foundation

final public class ImageCommentsPresenter {
  public static var title: String {
    return NSLocalizedString(
      "IMAGE_COMMENTS_VIEW_TITLE",
      tableName: "ImageComments",
      bundle: Bundle(for: ImageCommentsPresenter.self),
      comment: "Title for the image comments view"
    )
  }
 }
