//
//  WebViewViewControllerSpy.swift
//  Image FeedTests
//
//  Created by Леонид Турко on 16.11.2023.
//

import ImageFeed
import Foundation

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
  var presenter: WebViewPresenterProtocol?
  var loadRequestCalled = false
  
  
  func load(request: URLRequest) {
    loadRequestCalled = true
  }
  
  func setProgressValue(_ newValue: Float) {
    
  }
  
  func setProgressHidden(_ isHidden: Bool) {
    
  }
  
  
}
