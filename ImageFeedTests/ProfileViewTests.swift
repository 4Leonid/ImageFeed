//
//  ProfileViewTests.swift
//  ProfileViewTests
//
//  Created by Леонид Турко on 15.11.2023.
//

import XCTest
@testable import ImageFeed



final class ProfilePresenterSpy: ProfileViewPresenterProtocol {
  var viewDidLoadCalled: Bool = false
  var isCalled = false
  var view: ProfileViewControllerProtocol?
  
  var profileImageServiceObserver: NSObjectProtocol?
  
  func cleanAllService() {
    isCalled = true
  }
  
  func setupProfile(completion: @escaping ((ImageFeed.Profile) -> Void)) {
    //viewDidLoadCalled = true
  }
  
  func viewDidLoad() {
    viewDidLoadCalled = true
  }
  
  
}

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
  
  var presenter: ImageFeed.ProfileViewPresenterProtocol?
  var loadRequestCalled = false
  var avatarIsHere = false
  
  func configure(_ presenter: ProfileViewPresenterProtocol) {
   
  }
  
  func updateAvatar(url: URL) {
    avatarIsHere = true
  }
}

final class ProfileViewTests: XCTestCase {

  func testIsSetup() {
    //given
    let viewController = ProfileViewController()
    let presenter = ProfilePresenterSpy()
    viewController.presenter = presenter
    presenter.view = viewController
    
    //when
    _ = viewController.view
    
    //then
    //XCTAssertTrue(presenter.isCalled)
    XCTAssertTrue(presenter.viewDidLoadCalled)
  }
  
  func testAllClean() {
    //given
    let viewController = ProfileViewController()
    let presenter = ProfilePresenterSpy()
    viewController.configure(presenter)
    //presenter.view = viewController
    
    //when
    viewController.logOut()
    
    //then
    XCTAssertTrue(presenter.isCalled)
  }
  
 
//  func testIsViewControllerURL() {
//    let viewController = ProfileViewController()
//    var presenter = ProfilePresenterSpy()
//    
//    viewController.presenter = presenter
//    presenter.view = viewController
//    //var url = URL(string: "Hello")!
//    
//    viewController.updateAvatar(url: URL(string: "hell0")!)
//    
//    XCTAssertTrue(presenter.viewDidLoad())
//  }
  
}
