//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Леонид Турко on 15.11.2023.
//

import Foundation
import WebKit

protocol ProfileViewPresenterProtocol {
  var view: ProfileViewControllerProtocol? { get set }
  var profileImageServiceObserver: NSObjectProtocol? { get set }
  func cleanAllService()
  func setupProfile(completion: @escaping ((Profile) -> Void))
  func viewDidLoad()
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
  weak var view: ProfileViewControllerProtocol?
  weak var profileImageServiceObserver: NSObjectProtocol?
  
  func clean() {
    HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
    WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
      records.forEach { record in
        WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
      }
    }
  }
  
  func cleanAllService() {
    ProfileService.shared.cleanSession()
    ProfileImageService.shared.cleanSession()
    ImageListService.shared.cleanSession()
    clean()
  }
  
  func setupProfile(completion: @escaping ((Profile) -> Void)) {
    guard let profile = ProfileService.shared.profile else {
      assertionFailure("No profile")
      return
    }
    completion(profile)
    
    ProfileImageService.shared.fetchProfileImageURL(userName: profile.username) { _ in

    }
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
  }
}
