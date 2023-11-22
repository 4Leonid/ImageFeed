//
//  ImagesListViewPresenter.swift
//  ImageFeed
//
//  Created by Леонид Турко on 20.11.2023.
//

import Foundation

struct ImageListModel {
    var photos: [Photo] = []
}

public protocol ImagesListViewPresenterProtocol {
  var photos: [Photo] { get }
  func viewDidLoad()
  func tableViewExceed()
  func changeLike(for indexPath: IndexPath, completion: @escaping () -> Void)
  func timeSetup(_ date: Date) -> String
}

final class ImagesListViewPresenter: ImagesListViewPresenterProtocol {
  
  private let imagesListService: ImageListService
  private var model: ImageListModel
  private(set) weak var view: ImagesListViewControllerProtocol?
  
  private lazy var dateFormatter: DateFormatter = {
      let formatter = DateFormatter()
      formatter.dateFormat = "dd MMMM yyyy"
      formatter.locale = Locale(identifier: "ru_RU")
      return formatter
  }()
  
  var photos: [Photo] {
    model.photos
  }
  
  init(
    model: ImageListModel = .init(),
    imagesListService: ImageListService = ImageListService.shared
  ) {
    self.model = model
    self.imagesListService = imagesListService
  }
  
  func timeSetup(_ date: Date) -> String {
    dateFormatter.string(from: date)
  }
  
  func attach(_ view: ImagesListViewControllerProtocol) {
    self.view = view
  }
  
  func viewDidLoad() {
    imagesListService.fetchPhotosNextPage()
    makeSubscription()
  }
  
  func tableViewExceed() {
    imagesListService.fetchPhotosNextPage()
  }
  
  func changeLike(for indexPath: IndexPath, completion: @escaping () -> Void) {
    let photo = model.photos[indexPath.row]
    imagesListService.changeLike(photoId: photo.id, isLike: photo.isLiked) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success:
        self.model.photos = imagesListService.photos
        UIBlockingProgressHUD.dismiss()
        completion()
      case .failure:
        UIBlockingProgressHUD.dismiss()
        completion()
      }
    }
  }
}

private extension ImagesListViewPresenter {
  func makeSubscription() {
    NotificationCenter.default.addObserver(
      forName: ImageListService.didChangeNotification,
      object: nil,
      queue: .main
    ) { [weak self] _ in
      guard let self = self else { return }
      self.updateTableViewAnimated()
    }
  }
  
  private func updateTableViewAnimated() {
    let oldCount = model.photos.count
    let newCount = imagesListService.photos.count
    model.photos = imagesListService.photos
    guard oldCount != newCount else {
      return
    }
    view?.update(photos: model.photos)
  }
}
