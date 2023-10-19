//
//  Constants.swift
//  ImageFeed
//
//  Created by Леонид Турко on 18.03.2023.
//

import Foundation

struct Constants {
  //MARK: Unsplash api base paths
  static let DefaultBaseURL = "https://api.unsplash.com"
  static let baseURLString = "https://unsplash.com"
  static let authorizeURLString = "https://unsplash.com/oauth/authorize"
  static let baseAuthTokenPath = "/oauth/token"
  
  //MARK: Unsplash api constants
  static let accessKey = "2oxuuWAfl4iBv-cL1S_RDCOWOAAj_N8yQuTMoe6OcKg"
  static let secretKey = "CwEF_obM6SDk_pXzQ_yR2r7lVEx27G81n97megWDhxw"
  static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
  static let accessScope = "public+read_user+write_likes"
  
  //MARK: Unsplash storage constants
  static let bearerToken = "bearerToken"
}

struct NotificationConstants {
  static let profileImageProviderDidChange = "ProfileImageProviderDidChange"
}
