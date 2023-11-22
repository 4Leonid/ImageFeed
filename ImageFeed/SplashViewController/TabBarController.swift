//
//  TabBarViewController.swift
//  ImageFeed
//
//  Created by Леонид Турко on 25.04.2023.
//

import UIKit

final class TabBarController: UITabBarController {
  override func awakeFromNib() {
    super.awakeFromNib()
    let storyboard = UIStoryboard(name: "Main", bundle: .main)
    
    let imageListViewController = storyboard.instantiateViewController(withIdentifier: "ImageListViewController") as! ImagesListViewController
    let imageListPresenter = ImagesListViewPresenter()
    imageListViewController.presenter = imageListPresenter
    imageListPresenter.attach(imageListViewController)
    imageListViewController.tabBarItem = UITabBarItem(
      title: nil,
      image: UIImage(named: "tab_editorial_active"),
      selectedImage: nil
    )
    
    
    let profilePresenter = ProfileViewPresenter()
    let profileViewController = ProfileViewController(presenter: profilePresenter)
    profilePresenter.attach(profileViewController)
    profileViewController.tabBarItem = UITabBarItem(
      title: nil,
      image: UIImage(named: "tab_profile_active"),
      selectedImage: nil
    )
    
    viewControllers = [imageListViewController, profileViewController]
  }
}
