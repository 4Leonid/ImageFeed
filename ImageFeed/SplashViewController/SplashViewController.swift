//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Леонид Турко on 29.03.2023.
//

import UIKit
import ProgressHUD

class SplashViewController: UIViewController {
  //  MARK: - Private Properties
  private let ShowAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
  
  private let oauth2Service = OAuth2Service.shared
  private let oauth2TokenStorage = OAuth2TokenStorage.shared
  
  private let profileService = ProfileService.shared
  private let profileImageService = ProfileImageService.shared
  
  private lazy var splashImage: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.image = UIImage(named: "splash_screen_logo")
    return imageView
  }()
  
  //  MARK: - Override Methods
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    if let _ = oauth2TokenStorage.token {
      switchToTabBarController()
    } else {
      performSegue(withIdentifier: ShowAuthenticationScreenSegueIdentifier, sender: nil)
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setNeedsStatusBarAppearanceUpdate()
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    .lightContent
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .ypBlack
    addView()
    setupConstraints()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == ShowAuthenticationScreenSegueIdentifier {
      guard let navigationController = segue.destination as? UINavigationController,
            let viewController = navigationController.viewControllers[0] as? AuthViewController else {
              fatalError("No such identifier") }
      viewController.delegate = self
    } else {
      super.prepare(for: segue, sender: sender)
    }
  }
}

//  MARK: -  Private Methods
extension SplashViewController {
  private func addView() {
    view.addSubview(splashImage)
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      splashImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      splashImage.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])
  }
  
  private func switchToTabBarController() {
    guard let window = UIApplication.shared.windows.first else {
      fatalError("Invalid Configuration")
    }
    
    let tabBarController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "TabBarViewController")
    window.rootViewController = tabBarController
  }
}

//  MARK: -  AuthViewControllerDelegate
extension SplashViewController: AuthViewControllerDelegate {
  func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
    UIBlockingProgressHUD.show()
    dismiss(animated: true) { [weak self] in
      guard let self = self else { return }
      self.fetchOAuthToken(code)
      
    }
  }
  
  private func fetchOAuthToken(_ code: String) {
    oauth2Service.fetchOAuthToken(by: code) { [weak self] result  in
      guard let self = self else { return }
      switch result {
      case .success:
        self.switchToTabBarController()
        UIBlockingProgressHUD.show()
      case .failure:
        UIBlockingProgressHUD.dismiss()
      }
    }
  }
  
  private func fetchProfile(token: String) {
    profileService.fetchProfile(token) { [weak self] result in
      guard let self = self else { return }
      
      switch result {
      case .success(let profileResult):
        UIBlockingProgressHUD.dismiss()
        self.profileImageService.fetchProfileImageURL(profileResult.userName) {  _ in }
        self.switchToTabBarController()
      case .failure(let error):
        
      }
    }
  }
}
