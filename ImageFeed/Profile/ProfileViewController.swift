//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Леонид Турко on 02.03.2023.
//

import UIKit
import Kingfisher
import WebKit

public protocol ProfileViewControllerProtocol: AnyObject {
    func updateAvatar(url: URL)
    func update(profile: Profile)
}

final class ProfileViewController: UIViewController & ProfileViewControllerProtocol {

    private let presenter: ProfileViewPresenterProtocol

    init(presenter: ProfileViewPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  private lazy var avatarImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  private lazy var logoutButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    let buttonImage = UIImage(systemName: "ipad.and.arrow.forward")
    button.setImage(buttonImage, for: .normal)
    button.addTarget(self, action: #selector(didTapLogoutButton), for: .touchUpInside)
    button.tintColor = .ypRed
    button.accessibilityIdentifier = "logout button"
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
//    label.text = "Екатерина Новикова"
    label.textColor = .white
    label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
    return label
  }()
  
  private lazy var loginNameLabel: UILabel = {
    let label = UILabel()
//    label.text = "@ekaterina_nov"
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
    view.backgroundColor = .ypNewBlack
    setViews()
    setConstraints()
    presenter.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
//    presenter.setupProfile(completion: { [weak self] profile in
//      self?.nameLabel.text = profile.name
//      self?.descriptionLabel.text = profile.bio
//      self?.loginNameLabel.text = profile.loginName
//    })
  }
  
  //  MARK: - Public Methods
  @objc func didTapLogoutButton() {
    showAlert(
      title: "Выход",
      message: "Вы уверены что хотите выйти?") { [unowned self] in
        self.logOut()
      }
  }
  
    func updateAvatar(url: URL) {
        avatarImageView.kf.indicatorType = .activity
      let processor = RoundCornerImageProcessor(cornerRadius: 35, backgroundColor: .clear)
        avatarImageView.kf.setImage(with: url, options: [.processor(processor)])
    }

    func update(profile: Profile) {
        nameLabel.text = profile.name
        descriptionLabel.text = profile.bio
        loginNameLabel.text = profile.loginName
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
    presenter.cleanAllService()
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
