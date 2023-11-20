//
//  ImageListPresenterSpy.swift
//  Image FeedTests
//
//  Created by Леонид Турко on 20.11.2023.
//

import Foundation
import ImageFeed

final class ImageListPresenterSpy: ImagesListViewPresenterProtocol {
  func timeSetup(_ date: Date) -> String {
    return ""
  }
  
  var photos: [ImageFeed.Photo] = []
  var viewDidLoadCheck = false
  
  func viewDidLoad() {
    viewDidLoadCheck = true
  }
  
  func tableViewExceed() {
    
  }
  
  func changeLike(for indexPath: IndexPath, completion: @escaping () -> Void) {
    
  }
}
