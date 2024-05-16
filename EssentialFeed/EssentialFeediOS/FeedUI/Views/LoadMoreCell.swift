//
//  LoadMoreCell.swift
//  EssentialFeediOS
//
//  Created by Afsal on 16/05/2024.
//

import UIKit

public class LoadMoreCell: UITableViewCell {
  
  private lazy var spinner: UIActivityIndicatorView = {
    let spinner = UIActivityIndicatorView(style: .medium)
    contentView.addSubview(spinner)
    
    spinner.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      spinner.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      spinner.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      spinner.heightAnchor.constraint(lessThanOrEqualToConstant: 40)
    ])
    return spinner
  }()
  
  public var isLoading: Bool {
    get { spinner.isAnimating }
    set {
      if newValue {
        spinner.startAnimating()
      } else {
        spinner.stopAnimating()
      }
    }
  }
}
