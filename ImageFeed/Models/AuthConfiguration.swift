//
//  AuthConfiguration.swift
//  ImageFeed
//
//  Created by Леонид Турко on 18.03.2023.
//

import Foundation

enum Constants {
  static let accessKey = "2oxuuWAfl4iBv-cL1S_RDCOWOAAj_N8yQuTMoe6OcKg"
  static let secretKey = "CwEF_obM6SDk_pXzQ_yR2r7lVEx27G81n97megWDhxw"
  static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
  static let accessScope = "public+read_user+write_likes"
  static let defaultBaseURL = "https://api.unsplash.com"
  static let authURLString = "https://unsplash.com/oauth/authorize"
  
  static let baseAuthTokenPath = "/oauth/token"
  static let bearerToken = "bearerToken"
  static let profileImageProviderDidChange = "ProfileImageProviderDidChange"
}

struct AuthConfiguration {
  let accessKey: String
  let secretKey: String
  let redirectURI: String
  let accessScope: String
  let defaultBaseURL: String
  let authURLString: String
  
  init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, defaultBaseURL: String, authURLString: String) {
    self.accessKey = accessKey
    self.secretKey = secretKey
    self.redirectURI = redirectURI
    self.accessScope = accessScope
    self.defaultBaseURL = defaultBaseURL
    self.authURLString = authURLString
  }
  
  static var standart: AuthConfiguration {
    return AuthConfiguration(
      accessKey: Constants.accessKey,
      secretKey: Constants.secretKey,
      redirectURI: Constants.redirectURI,
      accessScope: Constants.accessScope,
      defaultBaseURL: Constants.defaultBaseURL,
      authURLString: Constants.authURLString
    )
  }
}

struct Auth {
  //MARK: Unsplash api base paths
  static let DefaultBaseURL = "https://api.unsplash.com"
  static let baseURLString = "https://unsplash.com"
  static let authorizeURLString = "https://unsplash.com/oauth/authorize"
  static let baseAuthTokenPath = "/oauth/token"
  
  //MARK: Unsplash api constants
  static let accessKey = "2oxuuWAfl4iBv-cL1S_RDCOWOAAj_N8yQuTMoe6OcKg"
  static let secretKey = "CwEF_obM6SDk_pXzQ_yR2r7lVEx27G81n97megWDhxw"
  
  //  static let accessKey = "7QKQeSqaqfMmIbgDG4LMPUJLVK-rdQ4lpa0rdIqQM4w"
  //  static let secretKey = "MJDZmFZ6dt3uyzYdOEWQsy7r0GkAB-SYkRBNJ3vBtGM"
  
  //  static let accessKey = "QyXklK4whSwhJ0UJd4ZQ17NU0uyRmaarFCrHA4Sqvm4"
  //  static let secretKey = "HcT1JeE5JxAKO42kovIldpMOcPLBxvEXhMdzgJS1aYM"
  
  //  static let accessKey = "3_Ji0bpekeVA2TlODFzum-Jap5A7z-4_Dcl72IrAehc"
  //  static let secretKey = "nG1T_hiZ6paaFaAa6d_tk8uMH8TlMM6xLWMTc8Hc7Ys"
  
  static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
  static let accessScope = "public+read_user+write_likes"
  
  //MARK: Unsplash storage constants
  static let bearerToken = "bearerToken"
}
