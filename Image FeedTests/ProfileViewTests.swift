//
//  ProfileViewTests.swift
//  ProfileViewTests
//
//  Created by Леонид Турко on 15.11.2023.
//

import XCTest
@testable import ImageFeed


final class ProfileViewTests: XCTestCase {
  
  func testLogOut() {
    //given
    let presenter = ProfileViewPresenter()
    let presenterSpy = ProfilePresenterSpy()
    let viewController = ProfileViewController(presenter: presenter)
    
    //when
    viewController.logOut()
    
    //then
    XCTAssertEqual(OAuth2TokenStorage.shared.token, nil)
  }
  
  func testAllClean() {
    //given
    let presenter = ProfilePresenterSpy()
    let viewController = ProfileViewController(presenter: presenter)
    
    //when
    viewController.logOut()
    
    //then
    XCTAssertTrue(presenter.isClean)
  }
  
  func testChangeWindowAfterLogOut() {
    //given
    let presenter = ProfilePresenterSpy()
    let viewController = ProfileViewController(presenter: presenter)
    
    //when
    viewController.logOut()
    
    guard let windows = UIApplication.shared.windows.first else {
      assertionFailure("Invalid Configuration")
      return
    }
    //then
    XCTAssertTrue(windows.rootViewController?.isKind(of: SplashViewController.self) == true)
  }
}

