//
//  Array+Extention.swift
//  ImageFeed
//
//  Created by Леонид Турко on 24.10.2023.
//

import Foundation
extension Array {
  @discardableResult
  func withReplaced(itemAt: Int, newValue: Photo) -> [Photo] {
    var photos = ImageListService.shared.photos
    photos.replaceSubrange(itemAt...itemAt, with: [newValue])
    return photos
  }
}
