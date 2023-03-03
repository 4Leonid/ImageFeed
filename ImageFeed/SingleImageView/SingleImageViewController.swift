//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Леонид Турко on 03.03.2023.
//

import UIKit

final class SingleImageViewController: UIViewController {
  @IBOutlet weak var imageView: UIImageView!
  
  var image: UIImage! {
    didSet {
      guard isViewLoaded else { return }
      imageView.image = image
    }
  }
  
    override func viewDidLoad() {
        super.viewDidLoad()

      imageView.image = image
    }
  
  @IBAction private func didTapBackButton() {
    dismiss(animated: true, completion: nil)
  }

}