//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Леонид Турко on 02.03.2023.
//

import UIKit
import Kingfisher
import WebKit

protocol ProfileViewControllerProtocol: AnyObject {
  var presenter: ProfileViewPresenterProtocol? { get set }
  func updateAvatar(url: URL)
  func configure(_ presenter: ProfileViewPresenterProtocol)
}

final class ProfileViewController: UIViewController & ProfileViewControllerProtocol {
  
  var presenter: ProfileViewPresenterProtocol?
  
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
    presenter?.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    presenter?.setupProfile(completion: { [weak self] profile in
      self?.nameLabel.text = profile.name
      self?.descriptionLabel.text = profile.bio
      self?.loginNameLabel.text = profile.loginName
    })
  }
  
  //  MARK: - Public Methods
  @objc func didTapLogoutButton() {
    showAlert(
      title: "Выход",
      message: "Вы уверены что хотите выйти?") { [unowned self] in
        self.logOut()
      }
  }
  
  func configure(_ presenter: ProfileViewPresenterProtocol) {
    self.presenter = presenter
    self.presenter?.view = self
  }
  
  func updateAvatar(url: URL) {
    avatarImageView.kf.indicatorType = .activity
    let processor = RoundCornerImageProcessor(cornerRadius: 61)
    avatarImageView.kf.setImage(with: url, options: [.processor(processor)])
  }
}

//  MARK: -  Private Methods
extension ProfileViewController {
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
  
  func logOut() {
    presenter?.cleanAllService()
    switchToSplashViewController()
  }
  
  private func switchToSplashViewController() {
    guard let window = UIApplication.shared.windows.first else {
      assertionFailure("Invalid configuration")
      return
    }
    window.rootViewController = SplashViewController()
  }
}


