//
//  ImageListCell.swift
//  ImageFeed
//
//  Created by Леонид Турко on 20.02.2023.
//

import UIKit

final class ImageListCell: UITableViewCell {
    //  MARK: - IB Outlets
    @IBOutlet var pictureImage: UIImageView!
    @IBOutlet var dataLabel: UILabel!
    @IBOutlet var likeButton: UIButton!
    
    //  MARK: - Public Properties
    static let reuseIdentifier = "ImagesListCell"
  
  override func prepareForReuse() {
    super.prepareForReuse()
    pictureImage.kf.cancelDownloadTask()
  }
    
}
