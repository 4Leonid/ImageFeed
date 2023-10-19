//
//  Profile.swift
//  ImageFeed
//
//  Created by Леонид Турко on 09.04.2023.
//

import Foundation

struct Profile {
  let username: String
  let name: String
  let loginName: String
  let bio: String?
}

extension Profile {
  init(result profile: ProfileResult) {
    self.init(
      username: profile.userLogin,
      name: "\(profile.firstName ?? "") \(profile.lastName ?? "")",
      loginName: "@\(profile.userLogin)",
      bio: profile.bio
    )
  }
}
