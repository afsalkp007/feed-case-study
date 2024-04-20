//
//  UITableView+Dequeueing.swift
//  EssentialFeediOS
//
//  Created by Afsal on 16/04/2024.
//

import UIKit

extension UITableView {
  func dequeueReusableCell<T: UITableViewCell>() -> T {
    let identifier: String = String(describing: T.self)
    return dequeueReusableCell(withIdentifier: identifier) as! T
  }
}
