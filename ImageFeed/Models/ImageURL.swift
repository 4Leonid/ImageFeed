//
//  ImageURL.swift
//  ImageFeed
//
//  Created by Леонид Турко on 10.04.2023.
//

import Foundation

struct ImageURL: Decodable {
  var profileImage: ProfileImageURL
  
  enum CodingKeys: String, CodingKey {
    case profileImage = "profile_image"
  }
}

struct ProfileImageURL: Decodable {
  let small: String
  let medium: String
}
