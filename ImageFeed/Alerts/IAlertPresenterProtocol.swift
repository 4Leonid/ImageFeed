//
//  IAlertPresenterProtocol.swift
//  ImageFeed
//
//  Created by Леонид Турко on 20.04.2023.
//

protocol IAlertPresenterProtocol {
  func preparingDataAndDisplay(alertText: String, handler: @escaping () -> Void)
}
