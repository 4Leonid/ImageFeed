//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Леонид Турко on 02.03.2023.
//

import UIKit
//import ProgressHUD
import Kingfisher
import WebKit

final class ProfileViewController: UIViewController {
  //  MARK: - Private Properties
  private var profileImageServiceObserver: NSObjectProtocol?
  private var oauthToken = OAuth2TokenStorage.shared
  
  private lazy var avatarImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    let profileImage = UIImage(named: "avatar")
    imageView.image = profileImage
    return imageView
  }()
  
  private lazy var logoutButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    let buttonImage = UIImage(systemName: "ipad.and.arrow.forward")
    button.setImage(buttonImage, for: .normal)
    button.addTarget(self, action: #selector(didTapLogoutButton), for: .touchUpInside)
    button.tintColor = .ypRed
    return button
  }()
  
  private lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.spacing = 8
    stackView.distribution = .fill
    return stackView
  }()
  
  private lazy var nameLabel: UILabel = {
    let label = UILabel()
    label.text = "Екатерина Новикова"
    label.textColor = .white
    label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
    return label
  }()
  
  private lazy var loginNameLabel: UILabel = {
    let label = UILabel()
    label.text = "@ekaterina_nov"
    label.textColor = .ypGray
    label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    return label
  }()
  
  private lazy var descriptionLabel: UILabel = {
    let label = UILabel()
    label.text = "Hello, world!"
    label.textColor = .white
    label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    return label
  }()
  
  //  MARK: - Public Properties
  override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
  
  //  MARK: - Override Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .ypBlack
    setViews()
    setConstraints()
    
    if let url = ProfileImageService.shared.avatarURL {
      updateAvatar(url: url)
    }
    
    profileImageServiceObserver = NotificationCenter.default.addObserver(
      forName: ProfileImageService.DidChangeNotification,
      object: nil,
      queue: .main
      ) { [weak self] notification  in
        guard let self = self else { return }
        self.updateAvatar(notification: notification)
      }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    guard let profile = ProfileService.shared.profile else {
      assertionFailure("No profile")
      return
    }
    nameLabel.text = profile.name
    descriptionLabel.text = profile.bio
    loginNameLabel.text = profile.loginName
    
    ProfileImageService.shared.fetchProfileImageURL(userName: profile.username) { _ in
      
    }
  }
  
  //  MARK: - Public Methods
  @objc func didTapLogoutButton() {
    showAlert()
  }
  
  static func clean() {
    HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
    WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
      records.forEach { record in
        WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
      }
    }
  }
}

//  MARK: -  Private Methods
extension ProfileViewController {
  private func updateAvatar(notification: Notification) {
    guard
      isViewLoaded,
      let userInfo = notification.userInfo,
      let profileImageURL = userInfo["URL"] as? String,
      let url = URL(string: profileImageURL)
    else { return }
    
    updateAvatar(url: url)
  }
  
  private func updateAvatar(url: URL) {
    avatarImageView.kf.indicatorType = .activity
    let processor = RoundCornerImageProcessor(cornerRadius: 61)
    avatarImageView.kf.setImage(with: url, options: [.processor(processor)])
  }
  
  private func setViews() {
    view.addSubview(avatarImageView)
    view.addSubview(logoutButton)
    view.addSubview(stackView)
    stackView.addArrangedSubview(nameLabel)
    stackView.addArrangedSubview(loginNameLabel)
    stackView.addArrangedSubview(descriptionLabel)
  }
  
  private func setConstraints() {
    NSLayoutConstraint.activate([
      avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
      avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
      logoutButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
      logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
      stackView.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
      stackView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
    ])
  }
  
  private func logOut() {
    cleanAllService()
    switchToSplashViewController()
  }
  
  private func cleanAllService() {
    ProfileService.shared.cleanSession()
    ProfileImageService.shared.cleanSession()
    ImageListService.shared.cleanSession()
    ProfileViewController.clean()
    //oauthToken.removeToken()
  }
  
  private func switchToSplashViewController() {
    guard let window = UIApplication.shared.windows.first else {
      assertionFailure("Invalid configuration")
      return
    }
    window.rootViewController = SplashViewController()
  }
  
  private func showAlert() {
    let alertController = UIAlertController(
      title: "Выход",
      message: "Вы уверены что хотите выйти",
      preferredStyle: .alert
    )
    
    let yesAction = UIAlertAction(title: "Да", style: .default) { [weak self] _ in
      guard let self = self else { return }
      self.logOut()
    }
    
    let noAction = UIAlertAction(title: "Нет", style: .default)
    alertController.addAction(yesAction)
    alertController.addAction(noAction)
    present(alertController, animated: true)
  }
}
