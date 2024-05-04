//
//  UIView+TestHelpers.swift
//  EssentialAppTests
//
//  Created by Afsal on 04/05/2024.
//

import UIKit

extension UIView {
  func enforceLayoutCycle() {
    layoutIfNeeded()
    RunLoop.current.run(until: Date())
  }
}
