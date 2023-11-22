//
//  ImageListViewTests.swift
//  Image FeedTests
//
//  Created by Леонид Турко on 20.11.2023.
//

import XCTest
@testable import ImageFeed

final class ImageListViewTests: XCTestCase {
  func testGetDateForCell() {
    //given
    let presenter = ImagesListViewPresenter()
    let viewController = ImagesListViewController()
    viewController.presenter = presenter
    
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/MM/dd HH:mm"
    guard let dateCell = formatter.date(from: "2023/07/28 11:11") else { return }
    
    //when
    let date = presenter.timeSetup(dateCell)
    
    //then
    XCTAssertEqual(date, "28 июля 2023")
  }
  
  func testViewControllerDidViewLoad() {
    //given
    let viewController = ImagesListViewController()
    let presenter = ImageListPresenterSpy()
    
    viewController.presenter = presenter
    //when
    presenter.viewDidLoad()
    //then
    XCTAssertTrue(presenter.viewDidLoadCheck)
  }
}
