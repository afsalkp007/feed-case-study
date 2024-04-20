//
//  UIRefreshControl+Helpers.swift
//  EssentialFeediOS
//
//  Created by Afsal on 20/04/2024.
//

import UIKit

extension UIRefreshControl {
  func update(_ isRefreshing: Bool) {
    isRefreshing ? beginRefreshing() : endRefreshing()
  }
}

