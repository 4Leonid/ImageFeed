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
  
  private let ShowAuthenticationScreefetchProfilenSegueIdentifier = "ShowAuthenticationSauthViewControllercreen"
  private let showAuthFlowIdentifier = "showAuthFlow" //
  
  private let oauth2Service = OAuth2Service.shared //
  private let oauth2TokenStorage = OAuth2TokenStorage.shared //
  
  private let profileService = ProfileService.shared //
  private let profileImageService = ProfileImageService.shared //
  
  private var authCode: String? //
  private var alertPresenter: IAlertPresenterProtocol! //
  
  private lazy var splashImage: UIImageView = { //
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.image = UIImage(named: "splash_screen_logo")
    return imageView
  }()
  
  //  MARK: - Override Methods
  override func viewDidLoad() { //
    super.viewDidLoad()
    view.backgroundColor = .ypBlack
    alertPresenter = AlertPresenter(delegate: self)
    addView()
    setupConstraints()
  }
  
  override func viewDidAppear(_ animated: Bool) { //
    super.viewDidAppear(animated)
    
    if let token = oauth2TokenStorage.token {
      fetchProfile(token: token)
    } else if authCode == nil {
      let authViewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "authVC")
      guard let authVC = authViewController as? AuthViewController else { return }
      authVC.delegate = self
      authVC.modalPresentationStyle = .fullScreen
      present(authVC, animated: true)
    }
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
    view.addSubview(splashImage)
  }
  
  private func setupConstraints() { //
    NSLayoutConstraint.activate([
      splashImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      splashImage.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])
  }
  
  private func switchToTabBarController() { //
    guard let window = UIApplication.shared.windows.first else {
      fatalError("Invalid Configuration")
    }
    
    let tabBarController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "TabBarViewController")
    window.rootViewController = tabBarController
  }
  
  private func fetchProfile(token: String) { //
    profileService.fetchProfile(token) { [weak self] result in
      guard let self = self else { return }
      
      switch result {
      case .success(let profileResult):
        UIBlockingProgressHUD.dismiss()
        self.profileImageService.fetchProfileImageURL(profileResult.userName) {  _ in }
        self.switchToTabBarController()
        
      case .failure(let error):
        self.alertPresenter.preparingDataAndDisplay(alertText: "Не удалось войти в систему. \(error.localizedDescription)") {
          self.performSegue(withIdentifier: self.showAuthFlowIdentifier, sender: nil)
          self.authCode = nil
        }
        UIBlockingProgressHUD.dismiss()
      }
    }
  }
}

extension SplashViewController: IAlertPresenterDelegate { //
  func showAlert(alert: UIAlertController) {
    self.present(alert, animated: true, completion: nil)
  }
}

//  MARK: -  AuthViewControllerDelegate
extension SplashViewController: AuthViewControllerDelegate { //
  func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
    UIBlockingProgressHUD.show()
    authCode = code
    
    vc.dismiss(animated: true) { [weak self] in
      guard let self = self else { return }
      
      OAuth2Service.shared.fetchOAuthToken(by: code) { result in
        switch result {
        case .success(let token):
          self.fetchProfile(token: token)
        case .failure(let error):
          self.alertPresenter.preparingDataAndDisplay(alertText: "Не удалось войти в систему. \(error.localizedDescription)") {
            self.performSegue(withIdentifier: self.showAuthFlowIdentifier, sender: nil)
            self.authCode = nil
          }
          UIBlockingProgressHUD.dismiss()
        }
      }
    }
  }
}
