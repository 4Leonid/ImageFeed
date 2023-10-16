//
//  ProfileResult.swift
//  ImageFeed
//
//  Created by Леонид Турко on 09.04.2023.
//

import Foundation

struct ProfileResult: Codable {
  let userLogin: String
  let firstName: String?
  let lastName: String?
  let bio: String?
  let profileImage: ProfileImage?
  
  enum CodingKeys: String, CodingKey {
    case userLogin = "username"
    case firstName = "first_name"
    case lastName = "last_name"
    case bio
    case profileImage = "profile_image"
  }
}

struct ProfileImage: Codable {
  let small: String?
  let medium: String?
  let large: String
}
