//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Леонид Турко on 29.03.2023.
//

import UIKit
import ProgressHUD
import SwiftUI

class SplashViewController: UIViewController {
  //  MARK: - Private Properties
 
  private let showAuthFlowIdentifier = "showAuthFlow" //
  
  private let oauth2Service = OAuth2Service() //
  private let profileService = ProfileService.shared //
  private var alertPresenter = AlertPresenter() //
  private var wasChecked = false
  
  private lazy var splashImage: UIImageView = { //
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.image = UIImage(named: "splash_screen_logo")
    return imageView
  }()
  
  //  MARK: - Override Methods
  override func viewDidLoad() { //
    super.viewDidLoad()
    addView()
    setupConstraints()
    alertPresenter.delegate = self
  }
  
  override func viewDidAppear(_ animated: Bool) { //
    super.viewDidAppear(animated)
    checkAuthStatus()
  }
  
  override func viewWillAppear(_ animated: Bool) { //
    super.viewWillAppear(animated)
    setNeedsStatusBarAppearanceUpdate()
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle { //
    .lightContent
  }
}

//  MARK: -  Private Methods
extension SplashViewController {
  private func addView() {
    view.backgroundColor = .ypBlack
    view.addSubview(splashImage)
  }
  
  private func setupConstraints() { //
    NSLayoutConstraint.activate([
      splashImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      splashImage.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])
  }
  
  private func checkAuthStatus() {
    guard !wasChecked else { return }
    wasChecked = true
    if oauth2Service.isAuthenticated {
      UIBlockingProgressHUD.show()
      
      fetchProfile { [weak self] in
        UIBlockingProgressHUD.dismiss()
        self?.switchToTabBarController()
      }
    } else {
    showAuthController()
    }
  }
  
  private func showAuthController() {
    let storyboard = UIStoryboard(name: "Main", bundle: .main)
    let viewController = storyboard.instantiateViewController(identifier: "AuthViewControllerID")
    guard let authViewController = viewController as? AuthViewController else { return }
    authViewController.delegate = self
    authViewController.modalPresentationStyle = .fullScreen
    present(authViewController, animated: true)
  }
  
  private func switchToTabBarController() { //
    guard let window = UIApplication.shared.windows.first else {
      fatalError("Invalid Configuration")
    }
    
    let tabBarController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "TabBarViewController")
    window.rootViewController = tabBarController
  }
}
  

//  MARK: -  AuthViewControllerDelegate
extension SplashViewController: AuthViewControllerDelegate { //
  func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
    
    dismiss(animated: true) { [weak self] in
      guard let self = self else { return }
      self.fetchOAuthToken(code)
    }
  }
  
  private func fetchOAuthToken(_ code: String) {
    UIBlockingProgressHUD.show()
    
    oauth2Service.fetchOAuthToken(code) { [weak self] authResult in
      switch authResult {
      case .success(_):
        self?.fetchProfile(completion: {
          UIBlockingProgressHUD.dismiss()
        })
      case .failure(let error):
        self?.showLoginAlert(error: error)
        UIBlockingProgressHUD.dismiss()
      }
    }
  }
  
  private func fetchProfile(completion: @escaping() -> Void) {
    profileService.fetchProfile { [weak self] profileResult in
      switch profileResult {
      case .success(_):
        self?.switchToTabBarController()
      case .failure(let error):
        self?.showLoginAlert(error: error)
      }
      completion()
    }
  }
  
  private func showLoginAlert(error: Error) {
    alertPresenter.showAlert(title: "Что-то пошло не так :(", message: "Не удалось войти в систему \(error.localizedDescription)") {
      self.performSegue(withIdentifier: self.showAuthFlowIdentifier, sender: nil)
    }
  }
}
