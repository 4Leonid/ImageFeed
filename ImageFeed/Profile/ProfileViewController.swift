//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Леонид Турко on 02.03.2023.
//

import UIKit
import ProgressHUD
import Kingfisher

final class ProfileViewController: UIViewController {
  //  MARK: - Private Properties
  private var profileImageServiceObserver: NSObjectProtocol?
  
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
    
    profileImageServiceObserver = NotificationCenter.default.addObserver(
      forName: ProfileImageService.DidChangeNotification,
      object: nil,
      queue: .main
      ) { [weak self] _ in
        guard let self = self else { return }
        self.updateAvatar()
      }
    updateAvatar()
  }
  
  //  MARK: - Public Methods
  @objc func didTapLogoutButton() { }
}

//  MARK: -  Private Methods
extension ProfileViewController {
  private func updateAvatar() {
    guard
      let profileImageURL = ProfileImageService.shared.avatarURL,
      let imageURL = URL(string: profileImageURL)
    else { return }
    
    avatarImageView.kf.indicatorType = .activity
    avatarImageView.kf.setImage(with: imageURL,
      placeholder: UIImage(systemName: "person.crop.circle"))
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
}
