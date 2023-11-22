//
//  WebViewPresenterSpy.swift
//  Image FeedTests
//
//  Created by Леонид Турко on 16.11.2023.
//

import ImageFeed
import Foundation

final class WebViewPresenterSpy: WebViewPresenterProtocol {
  var viewDidLoadCalled = false
  var view: WebViewViewControllerProtocol?
  
  func viewDidLoad() {
    viewDidLoadCalled = true
  }
  
  func didUpdatePregressValue(_ newValue: Double) {
    
  }
  
  func code(from url: URL) -> String? {
    return nil 
  }
  
  
}
