//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Леонид Турко on 02.03.2023.
//

import UIKit

class ProfileViewController: UIViewController {
  //  MARK: - IB Outlets
  @IBOutlet weak private var avatarImageView: UIImageView!
  @IBOutlet weak private var nameLabel: UILabel!
  @IBOutlet weak private var loginNameLabel: UILabel!
  @IBOutlet weak private var descriptionLabel: UILabel!
  @IBOutlet weak private var logoutButton: UIButton!
  
  //  MARK: - IB Actions
  @IBAction func didTapLogoutButton() {}
}
