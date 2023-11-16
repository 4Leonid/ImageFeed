//
//  UIViewController+Extention.swift
//  ImageFeed
//
//  Created by Леонид Турко on 15.11.2023.
//

import UIKit

extension UIViewController {
  func showAlert(title: String, message: String, completion: @escaping(() -> Void)) {
    let alertController = UIAlertController(
      title: title,
      message: message,
      preferredStyle: .alert
    )
    
    let yesAction = UIAlertAction(title: "Да", style: .default) { _ in
      completion()
    }
    
    let noAction = UIAlertAction(title: "Нет", style: .default)
    alertController.addAction(yesAction)
    alertController.addAction(noAction)
    present(alertController, animated: true)
    
  }
}
