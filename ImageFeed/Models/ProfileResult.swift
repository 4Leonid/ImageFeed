//
//  ProfileResult.swift
//  ImageFeed
//
//  Created by Леонид Турко on 09.04.2023.
//

import Foundation

struct ProfileResult: Codable {
  let userName: String
  let firstName: String
  let lastName: String
  var bio: String?
  
  enum CodingKeys: String, CodingKey {
    case userName = "username"
    case firstName = "first_name"
    case lastName = "last_name"
    case bio
  }
}


