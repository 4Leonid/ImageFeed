//
//  AuthConfiguration.swift
//  ImageFeed
//
//  Created by Леонид Турко on 18.03.2023.
//

import Foundation

struct AuthConfiguration {
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

struct NotificationConstants {
  static let profileImageProviderDidChange = "ProfileImageProviderDidChange"
}
