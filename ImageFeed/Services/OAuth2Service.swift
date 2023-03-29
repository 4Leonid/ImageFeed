//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Леонид Турко on 28.03.2023.
//

import Foundation

final class OAuth2Service {
  static let shared = OAuth2Service()
  private let urlSession = URLSession.shared
  private let tokenStorage = OAuth2TokenStorage.shared
  
  private (set) var authToken: String? {
    get {
      return tokenStorage.token
    }
    set {
      tokenStorage.token = newValue
    }
  }
  
  private init() {}
  
  func fetchOAuthToken(by code: String, completion: @escaping (Result<String, Error>) -> Void ) {
    guard let urlRequest = authTokenRequest(code: code) else { fatalError("No token") }
    
    let task = object(for: urlRequest) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let body):
        let authToken = body.accessToken
        self.authToken = authToken
        completion(.success(authToken))
      case .failure(let error):
        completion(.failure(error))
      }
    }
    task.resume()
  }
  
  private func object(for request: URLRequest, completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void) -> URLSessionTask {
    let decoder = JSONDecoder()
    
    return urlSession.data(for: request) { (result: Result<Data, Error>) in
      let response = result.flatMap { data -> Result<OAuthTokenResponseBody, Error> in
        Result {
          try decoder.decode(OAuthTokenResponseBody.self, from: data)
        }
      }
      completion(response)
    }
  }
}

extension OAuth2Service {
  private func selfProfileRequest() -> URLRequest? {
      URLRequest.makeHTTPRequest(path: "/me")
  }
  
  func profileImageURLRequest(username: String) -> URLRequest? {
      URLRequest.makeHTTPRequest(path: "/users/\(username)")
  }
  
  func photosRequest(page: Int, perPage: Int) -> URLRequest? {
      URLRequest.makeHTTPRequest(path: "/photos?"
        + "page=\(page)"
        + "&&per_page=\(perPage)"
      )
  }
  
  func likeRequest(photoId: String) -> URLRequest? {
      URLRequest.makeHTTPRequest(
        path: "/photos/\(photoId)/like",
        httpMethod: "POST"
      )
  }
  
  func unlikeRequest(photoId: String) -> URLRequest? {
      URLRequest.makeHTTPRequest(
        path: "/photos/\(photoId)/like",
        httpMethod: "DELETE"
      )
  }
  
  private func authTokenRequest(code: String) -> URLRequest? {
    URLRequest.makeHTTPRequest(
      path: Constants.baseAuthTokenPath
      + "?client_id=\(Constants.AccessKey)"
      + "&&client_secret=\(Constants.SecretKey)"
      + "&&redirect_uri=\(Constants.RedirectURI)"
      + "&&code=\(code)"
      + "&&grant_type=authorization_code",
      httpMethod: "POST",
      baseURL: URL(string: "https://unsplash.com")!
    )
  }
}

