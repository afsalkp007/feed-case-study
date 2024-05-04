//
//  HTTPURLResponse+StatusCode.swift
//  EssentialFeed
//
//  Created by Afsal on 23/04/2024.
//

import Foundation

extension HTTPURLResponse {
  private static var OK_200: Int { 200 }
  
  var isOK: Bool {
    return statusCode == Self.OK_200
  }
}
