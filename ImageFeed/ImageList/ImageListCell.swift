//
//  ImageListCell.swift
//  ImageFeed
//
//  Created by Леонид Турко on 20.02.2023.
//

import UIKit

protocol ImagesListCellDelegate: AnyObject {
  func imageListCellDidTapLike(_ cell: ImageListCell)
}

final class ImageListCell: UITableViewCell {
  //  MARK: - IB Outlets
  @IBOutlet var pictureImage: UIImageView!
  @IBOutlet var dataLabel: UILabel!
  @IBOutlet var likeButton: UIButton!
  
  //  MARK: - Public Properties
  static let reuseIdentifier = "ImagesListCell"
  weak var delegate: ImagesListCellDelegate?
  
  override func prepareForReuse() {
    super.prepareForReuse()
    pictureImage.kf.cancelDownloadTask()
  }
  
  @IBAction private func likeButtonClicked() {
    delegate?.imageListCellDidTapLike(self)
  }
  
  func setIsLiked(isLiked: Bool) {
    let likeImage = isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
    likeButton.setImage(likeImage, for: .normal)
  }
}
