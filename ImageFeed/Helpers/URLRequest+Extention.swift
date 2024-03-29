//
//  URLRequest+Extention.swift
//  ImageFeed
//
//  Created by Леонид Турко on 29.03.2023.
//

import Foundation


final class URLRequestBuilder {
  static let shared = URLRequestBuilder()
  private let storage: OAuth2TokenStorage
  
  init(storage: OAuth2TokenStorage = .shared) {
    self.storage = storage
  }
  
  func makeHTTPRequest(path: String, httpMethod: String, baseURLString: String) -> URLRequest? {
    
    guard
      let url = URL(string: baseURLString),
      let baseURL = URL(string: path, relativeTo: url)
    else { return nil }
    
    var request = URLRequest(url: baseURL)
    request.httpMethod = httpMethod
    
    if let token = storage.token {
      request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }
    return request
  }
}
