//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Леонид Турко on 02.03.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
  //  MARK: - Private Properties
  private var avatarImageView: UIImageView?

  //  MARK: - Public Properties
  override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
  
  //  MARK: - Override Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .ypBlack
    setupImage()
    setupButton()
    setupLabels()
  }
  
  //  MARK: - Public Methods
  @objc func didTapLogoutButton() { }
}

//  MARK: -  Private Methods
extension ProfileViewController {
  private func setupImage() {
    guard let profileImage = UIImage(named: "avatar") else { return }
    let imageView = UIImageView()
    imageView.image =  profileImage
    imageView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(imageView)
    self.avatarImageView = imageView
    
    NSLayoutConstraint.activate([
      imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
      imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
    ])
  }
  
  private func setupButton() {
    guard let buttonImage = UIImage(systemName: "ipad.and.arrow.forward") else { return }
    guard let avatarImageView = avatarImageView else { return }
 
    let button = UIButton.systemButton(
      with: buttonImage,
      target: self,
      action: #selector(didTapLogoutButton)
    )
    button.tintColor = .ypRed
    button.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(button)
    
    NSLayoutConstraint.activate([
      button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
      button.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor)
    ])
  }
  
  private func setupLabels() {
    guard let avatarImageView = avatarImageView else { return }
    let nameLabel = UILabel()
    nameLabel.text = "Екатерина Новикова"
    nameLabel.font = UIFont.systemFont(ofSize: 23, weight: .bold)
    nameLabel.textColor = .white
    
    let loginNameLabel = UILabel()
    loginNameLabel.text = "@ekaterina_nov"
    loginNameLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    loginNameLabel.textColor = .ypGray
    
    let descriptionLabel = UILabel()
    descriptionLabel.text = "Hello, world!"
    descriptionLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    descriptionLabel.textColor = .white
    
    let stackView = UIStackView()
    stackView.distribution = .fill
    stackView.axis = .vertical
    stackView.spacing = 8
    stackView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(stackView)

    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 10),
      stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
      stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
    ])

    stackView.addArrangedSubview(nameLabel)
    stackView.addArrangedSubview(loginNameLabel)
    stackView.addArrangedSubview(descriptionLabel)
  }
}
