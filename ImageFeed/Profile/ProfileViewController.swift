//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Леонид Турко on 02.03.2023.
//

import UIKit

class ProfileViewController: UIViewController {
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
  
  @objc func didTapLogoutButton() { }
}

extension ProfileViewController {
  //  MARK: -  Private Methods
  private func setupImage() {
    guard let profileImage = UIImage(named: "avatar") else { return }
    let imageView = UIImageView()
    imageView.image =  profileImage
    imageView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(imageView)
    self.avatarImageView = imageView
    
    imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
    imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
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
    
    button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
    button.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor).isActive = true
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

    stackView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 10).isActive = true
    stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
    stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 16).isActive = true
    
    stackView.addArrangedSubview(nameLabel)
    stackView.addArrangedSubview(loginNameLabel)
    stackView.addArrangedSubview(descriptionLabel)
  }
}
