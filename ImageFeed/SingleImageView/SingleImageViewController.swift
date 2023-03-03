//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Леонид Турко on 03.03.2023.
//

import UIKit

final class SingleImageViewController: UIViewController {
  //  MARK: - IB Outlets
  @IBOutlet weak var imageView: UIImageView!
  
  //  MARK: - Public Properties
  var image: UIImage! {
    didSet {
      guard isViewLoaded else { return }
      imageView.image = image
    }
  }
  
  //  MARK: - Override Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    
    imageView.image = image
  }
  
  //  MARK: - IB Actions
  @IBAction private func didTapBackButton() {
    dismiss(animated: true, completion: nil)
  }
  
}
