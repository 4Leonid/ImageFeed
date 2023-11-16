//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Леонид Турко on 10.04.2023.
//

import Foundation

final class ProfileImageService {
  static let shared = ProfileImageService()
  static let DidChangeNotification = Notification.Name(Constants.profileImageProviderDidChange.rawValue)
  
  private (set) var avatarURL: URL?
  private var currentTask: URLSessionTask?
  private let urlBuilder = URLRequestBuilder.shared
  
  private init() {}
  
  func fetchProfileImageURL(userName: String, completion: @escaping (Result<String, Error>) -> Void) {
    assert(Thread.isMainThread)
    guard let request = profileImageRequest(username: userName) else { return }
    let session = URLSession.shared
    let task = session.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
      guard let self = self else { return }
      
      switch result {
      case .success(let profilePhoto):
        guard let mediumPhoto = profilePhoto.profileImage?.medium else { return }
        self.avatarURL = URL(string: mediumPhoto)
        completion(.success(mediumPhoto))
        
        NotificationCenter.default.post(
          name: ProfileImageService.DidChangeNotification,
          object: self,
          userInfo: ["URL": mediumPhoto]
        )
      case .failure(let error):
        completion(.failure(error))
      }
      self.currentTask = nil
    }
    currentTask = task
    task.resume()
  }
  
  func cleanSession() {
    currentTask?.cancel()
    currentTask = nil
    avatarURL = nil
  }
}

extension ProfileImageService {
  private func profileImageRequest(username: String) -> URLRequest? {
    urlBuilder.makeHTTPRequest(
      path: "/users/\(username)",
      httpMethod: "GET",
      baseURLString: Constants.defaultBaseURL.rawValue
    )
  }
}
