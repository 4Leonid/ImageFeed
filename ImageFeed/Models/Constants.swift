//
//  Constants.swift
//  ImageFeed
//
//  Created by Леонид Турко on 18.03.2023.
//

import Foundation

struct Constants {
  static let AccessKey = "2oxuuWAfl4iBv-cL1S_RDCOWOAAj_N8yQuTMoe6OcKg"
  static let SecretKey = "CwEF_obM6SDk_pXzQ_yR2r7lVEx27G81n97megWDhxw"
  static let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
  static let AccessScope = "public+read_user+write_likes"
  static let DefaultBaseURL = URL(string: "https://api.unsplash.com")!
  static let bearerToken = "bearerToken"
  static let baseAuthTokenPath = "/oauth/token"
}

struct NotificationConstants {
  static let profileImageProviderDidChange = "ProfileImageProviderDidChange"
}
