//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Леонид Турко on 28.03.2023.
//

import Foundation

final class OAuth2Service {
  private let urlSession: URLSession
  private let storage: OAuth2TokenStorage
  private let builder: URLRequestBuilder
  
  private var currentTask: URLSessionTask?
  private var lastCode: String?
  
  var isAuthenticated: Bool {
    storage.token != nil
  }
  
  init(
    urlSession: URLSession = .shared,
    storage: OAuth2TokenStorage = .shared,
    builder: URLRequestBuilder = .shared
  ) {
    self.urlSession = urlSession
    self.storage = storage
    self.builder = builder
  }
  
  func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void ) {
    
    //assert(Thread.isMainThread, "Bad thread befor fetch token!")
    if lastCode == code { return }
    
    currentTask?.cancel()
    lastCode = code
    
    guard let urlRequest = authTokenRequest(code: code) else {
      assertionFailure("Invalid request")
      completion(.failure(NetworkError.invalidRequest))
      return
    }
    
    let session = URLSession.shared
    currentTask = session.objectTask(for: urlRequest) { [weak self] (response: Result<OAuthTokenResponseBody, Error>) in
     
      switch response {
      case .success(let body):
        let authToken = body.accessToken
        self?.storage.token = authToken
        completion(.success(authToken))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
}

extension OAuth2Service {
  
  private func authTokenRequest(code: String) -> URLRequest? {
    builder.makeHTTPRequest(
      path: "\(Constants.baseAuthTokenPath)"
      + "?client_id=\(Constants.accessKey)"
      + "&&client_secret=\(Constants.secretKey)"
      + "&&redirect_uri=\(Constants.redirectURI)"
      + "&&code=\(code)"
      + "&&grant_type=authorization_code",
      httpMethod: "POST",
      baseURLString: "https://unsplash.com"//Constants.defaultBaseURL
    )
  }
}

