//
//  UIButton+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by Afsal on 06/04/2024.
//

import UIKit

extension UIButton {
  func simulateTap() {
    simulate(event: .touchUpInside)
  }
}

