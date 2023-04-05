//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Леонид Турко on 28.03.2023.
//

import Foundation

final class OAuth2TokenStorage {
  static let shared = OAuth2TokenStorage()
  private let userDefault = UserDefaults.standard
  
  var token: String? {
    get {
      userDefault.string(forKey: Constants.bearerToken)
    }
    set {
      userDefault.set(newValue, forKey: Constants.bearerToken)
    }
  }
  
  private init() {}
}
