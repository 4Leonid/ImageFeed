//
//  ImageListService.swift
//  ImageFeed
//
//  Created by Леонид Турко on 20.10.2023.
//

import UIKit

final class ImageListService {
  private (set) var photos: [Photo] = []
  private var lastLoadedPage: Int?
  private var task: URLSessionTask?
  private let oauth2TokenStorage = OAuth2TokenStorage.shared
  private let builder: URLRequestBuilder
  private let dateFormater = ISO8601DateFormatter()
  static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
  private let page = "10"
  
  init(builder: URLRequestBuilder = .shared) {
    self.builder = builder
  }
  
  func fetchPhotosNextPage() {
    assert(Thread.isMainThread)
    guard task == nil else {
      print("Fetching in progress. Cannot start a new request.")
      return
    }
    let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
    guard let token = oauth2TokenStorage.token else { return }
    guard let request = fetchImageListRequest(token, page: String(nextPage), perPage: page) else { return }
    
    let session = URLSession.shared
    let dataTask = session.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
      DispatchQueue.main.async { [weak self] in
        guard let self else { return }
        self.task = nil
        switch result {
        case .success(let photoResults):
          photoResults.forEach { [weak self] image in
            guard let newPhoto = self?.createPhoto(image) else { return }
            self?.photos.append(newPhoto)
          }
          NotificationCenter.default.post(name: ImageListService.didChangeNotification, object: nil)
          self.lastLoadedPage = nextPage
        case .failure(let error):
          assertionFailure("Cant get image \(error)")
        }
      }
    }
    task = dataTask
    dataTask.resume()
  }
  
  private func fetchImageListRequest(_ token: String, page: String, perPage: String) -> URLRequest? {
    let request = builder.makeHTTPRequest(
      path: "/photos?page=\(page)&&per_page=\(perPage)",
      httpMethod: "GET",
      baseURLString: Constants.DefaultBaseURL
    )
    return request
  }
  
  private func createPhoto(_ photoResult: PhotoResult) -> Photo {
    let date = dateFormater.date(from: photoResult.createdAt ?? "")
    let thumbImage = photoResult.urls?.thumb ?? ""
    let fullImage = photoResult.urls?.full ?? ""
    
    let photo = Photo(
      id: photoResult.id,
      size: CGSize(width: photoResult.width ?? 0, height: photoResult.height ?? 0),
      createdAt: date,
      welcomeDescription: photoResult.description,
      thumbImageURL: thumbImage,
      largeImageURL: fullImage,
      isLiked: photoResult.isLiked ?? false
    )
    return photo
  }
}

struct Photo {
  let id: String
  let size: CGSize
  let createdAt: Date?
  let welcomeDescription: String?
  let thumbImageURL: String?
  let largeImageURL: String?
  let isLiked: Bool
}

struct PhotoResult: Codable {
  let id: String
  let createdAt: String?
  let updatedAt: String?
  let description: String?
  let isLiked: Bool?
  let width: Int?
  let height: Int?
  let urls: UrlsResult?
  enum CodingKeys: String, CodingKey {
    case id = "id"
    case createdAt = "created_at"
    case updatedAt = "updated_at"
    case description = "description"
    case isLiked = "liked_by_user"
    case width = "width"
    case height = "height"
    case urls = "urls"
  }
}

struct UrlsResult: Codable {
  let raw: String
  let full: String
  let regular: String
  let small: String
  let thumb: String
}
