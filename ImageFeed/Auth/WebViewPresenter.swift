//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Леонид Турко on 16.11.2023.
//

import Foundation

fileprivate let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"

public protocol WebViewPresenterProtocol {
  var view: WebViewViewControllerProtocol? { get set }
  func viewDidLoad()
  func didUpdatePregressValue(_ newValue: Double)
  func code(from url: URL) -> String?
}

final class WebViewPresenter: WebViewPresenterProtocol {
  weak var view: WebViewViewControllerProtocol?
  var authHelper: AuthHelperProtocol
  
  init(authHelper: AuthHelperProtocol) {
    self.authHelper = authHelper
  }
  
  func viewDidLoad() {
    let request = authHelper.authRequest()
    view?.load(request: request)
    didUpdatePregressValue(0)
  }
  
  func didUpdatePregressValue(_ newValue: Double) {
    let newProgressValue = Float(newValue)
    view?.setProgressValue(newProgressValue)
    
    let shouldHideProgress = shouldHideProgress(for: newProgressValue)
    view?.setProgressHidden(shouldHideProgress)
  }
  
  func shouldHideProgress(for value: Float) -> Bool {
    abs(value - 1.0) <= 0.0001
  }
  
  func code(from url: URL) -> String? {
    authHelper.code(from: url)
  }
}
