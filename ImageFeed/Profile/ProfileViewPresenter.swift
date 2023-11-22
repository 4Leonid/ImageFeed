//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Леонид Турко on 15.11.2023.
//

import Foundation
import WebKit

public protocol ProfileViewPresenterProtocol {
  var profileImageServiceObserver: NSObjectProtocol? { get set }
  func cleanAllService()
  func viewDidLoad()
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
  
  private let imagesListService: ImageListService
  private let profileService: ProfileService
  private let profileImageService: ProfileImageService
  
  
  init(
    imagesListService: ImageListService = .shared,
    profileService: ProfileService = .shared,
    profileImageService: ProfileImageService = .shared
  ) {
    self.imagesListService = imagesListService
    self.profileService = profileService
    self.profileImageService = profileImageService
  }
  
  private(set) weak var view: ProfileViewControllerProtocol?
  weak var profileImageServiceObserver: NSObjectProtocol?
  
  func clean() {
    HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
    WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
      records.forEach { record in
        WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
      }
    }
  }
  
  func attach(_ view: ProfileViewControllerProtocol) {
    self.view = view
  }
  
  func cleanAllService() {
    profileService.cleanSession()
    profileImageService.cleanSession()
    imagesListService.cleanSession()
    clean()
  }
  
  func viewDidLoad() {
    profileImageServiceObserver = NotificationCenter.default.addObserver(
      forName: ProfileImageService.DidChangeNotification,
      object: nil,
      queue: .main
    ) { [weak self] notification  in
      guard let self = self else { return }
      guard
        //view?.isViewLoaded,
        let userInfo = notification.userInfo,
        let profileImageURL = userInfo["URL"] as? String,
        let url = URL(string: profileImageURL)
      else { return }
      
      view?.updateAvatar(url: url)
    }
    setupProfile()
  }
}


private extension ProfileViewPresenter {
  func setupProfile() {
    guard let profile = ProfileService.shared.profile else {
      return
    }
    view?.update(profile: profile)
    
    ProfileImageService.shared.fetchProfileImageURL(userName: profile.username) { _ in
      
    }
  }
}
