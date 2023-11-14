//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Леонид Турко on 09.04.2023.
//

import Foundation
import FileProvider
import UIKit

final class ProfileService {
  static let shared = ProfileService()
  private(set) var profile: Profile?
  private var currentTask: URLSessionTask?
  private let builder: URLRequestBuilder
  
  init(builder: URLRequestBuilder = .shared) {
    self.builder = builder
  }
  
  func fetchProfile(completion: @escaping (Result<Profile, Error>) -> Void) {
    
    currentTask?.cancel()
    guard let urlRequest = makeFetchProfileRequest() else {
      assertionFailure("Invalid request")
      completion(.failure(NetworkError.invalidRequest))
      return
    }
    
    let session = URLSession.shared
    currentTask = session.objectTask(for: urlRequest) { [weak self] (response: Result<ProfileResult, Error>) in
      
      self?.currentTask = nil
      switch response {
      case .success(let profileResult):
        let profile = Profile(result: profileResult)
        self?.profile = profile
        completion(.success(profile))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
  
  private func makeFetchProfileRequest() -> URLRequest? {
    builder.makeHTTPRequest(
      path: "/me",
      httpMethod: "GET",
      baseURLString: Constants.DefaultBaseURL
    )
  }
  
  func cleanSession() {
    currentTask?.cancel()
    currentTask = nil 
    //OAuth2TokenStorage.shared.token = nil
    OAuth2TokenStorage.shared.removeToken()
    profile = nil
  }
}

