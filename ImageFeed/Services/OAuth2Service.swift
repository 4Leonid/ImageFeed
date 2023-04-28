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
  private let networkClient = NetworkClient.shared
  
  private var currentTast: URLSessionTask?
  private var lastCode: String?
  
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
    
    assert(Thread.isMainThread, "Bad thread befor fetch token!")
    if currentTast != nil {
      if lastCode != code {
        currentTast?.cancel()
      } else {
        return
      }
    } else {
      if lastCode == code {
        return
      }
    }
    lastCode = code
    
    guard let urlRequest = authTokenRequest(code: code) else { fatalError("Bad request") }
    
    let task = networkClient.getObject(dataType: OAuthTokenResponseBody.self, for: urlRequest) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let object):
        let authToken = object.accessToken
        self.authToken = authToken
        completion(.success(authToken))
      case .failure(let error):
        completion(.failure(error))
        self.lastCode = nil
      }
      self.currentTast = nil
    }
    currentTast = task
    task.resume()
  }
}
  /*
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
   */

extension OAuth2Service {
  private func selfProfileRequest() -> URLRequest? {
      URLRequest.makeHTTPRequest(path: "/me")
  }
  
  func profileImageURLRequest(username: String) -> URLRequest? {
      URLRequest.makeHTTPRequest(path: "/users/\(username)")
  }
  
  func photosRequest(page: Int, perPage: Int) -> URLRequest? { //1
      URLRequest.makeHTTPRequest(path: "/photos?"
        + "page=\(page)"
        + "&&per_page=\(perPage)"
      )
  }
  
  func likeRequest(photoId: String) -> URLRequest? { //2
      URLRequest.makeHTTPRequest(
        path: "/photos/\(photoId)/like",
        httpMethod: "POST"
      )
  }
  
  func unlikeRequest(photoId: String) -> URLRequest? { //3
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

