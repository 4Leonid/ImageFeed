//
//  URLRequest+Extention.swift
//  ImageFeed
//
//  Created by Леонид Турко on 29.03.2023.
//

import Foundation

extension URLRequest {
  static func makeHTTPRequest(
    path: String,
    httpMethod: String = "GET",
    baseURL: URL = Constants.DefaultBaseURL
  ) -> URLRequest? {
    var request = URLRequest(url: URL(string: path, relativeTo: baseURL)!)
    request.httpMethod = httpMethod
    return request
  }
}
