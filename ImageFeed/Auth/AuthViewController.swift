//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Леонид Турко on 20.03.2023.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
  func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}

final class AuthViewController: UIViewController {
  private let ShowWebViewSegueIdentifier = "ShowWebView"
  
  weak var delegate: AuthViewControllerDelegate?
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard segue.identifier == ShowWebViewSegueIdentifier else { return }
    guard let webViewViewController = segue.destination as? WebViewViewController else { return }
    webViewViewController.delegate = self
    
  }
}

//  MARK: - WebViewViewControllerDelegate
extension AuthViewController: WebViewViewControllerDelegate {
  func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
    delegate?.authViewController(self, didAuthenticateWithCode: code)
  }
  
  func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
    dismiss(animated: true)
  }
}
