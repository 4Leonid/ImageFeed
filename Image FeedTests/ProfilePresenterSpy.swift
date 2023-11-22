//
//  ProfilePresenterSpy.swift
//  ImageFeedTests
//
//  Created by Леонид Турко on 20.11.2023.
//

import Foundation
import ImageFeed

final class ProfilePresenterSpy: ProfileViewPresenterProtocol {
  var profileImageServiceObserver: NSObjectProtocol?
  
  var viewDidLoadCalled = false
  var isClean = false
  
  func cleanAllService() {
    isClean = true
  }
  
  func viewDidLoad() {
    viewDidLoadCalled = true
  }
//  var view: ProfileViewControllerProtocol?
  
//  var profileImageServiceObserver: NSObjectProtocol?
  
//  func cleanAllService() {
//    isClean = true
//  }
//  
//  func setupProfile(completion: @escaping ((ImageFeed.Profile) -> Void)) {
//    //viewDidLoadCalled = true
//  }
//  
//  func viewDidLoad() {
//    viewDidLoadCalled = true
//  }
}
