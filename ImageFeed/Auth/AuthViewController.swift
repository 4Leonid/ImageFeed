//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Леонид Турко on 20.03.2023.
//

import UIKit

final class AuthViewController: UIViewController {
  private let ShowWebViewSegueIdentifier = "ShowWebView"
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard segue.identifier == ShowWebViewSegueIdentifier else { return }
    guard let webViewViewController = segue.destination as? WebViewViewController else { return }
    webViewViewController.delegate = self
    
  }
}

extension AuthViewController: WebViewViewControllerDelegate {
  func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
    // TODO
  }
  
  func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
    dismiss(animated: true)
  }
}
  
  /*
  private lazy var authImage: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.image = UIImage(named: "auth_screen_logo")
    
    return imageView
  }()
  
  private lazy var authButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.layer.cornerRadius = 16
    button.backgroundColor = .white
    button.setTitle("Войти", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .ypBlack
    addViews()
    setupConstraints()
  }
  
  private func addViews() {
    view.addSubview(authImage)
    view.addSubview(authButton)
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      authImage.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      authImage.safeAreaLayoutGuide.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      
      authButton.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      authButton.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      authButton.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 48),
      authButton.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -124),
      authButton.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: view.centerXAnchor)
    ])
  }
}
*/
