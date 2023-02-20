//
//  ImageListCell.swift
//  ImageFeed
//
//  Created by Леонид Турко on 20.02.2023.
//

import UIKit

final class ImageListCell: UITableViewCell {
    @IBOutlet var pictureImage: UIImageView!
    @IBOutlet var dataLabel: UILabel!
    @IBOutlet var likeButton: UIButton!
    
    static let reuseIdentifier = "ImagesListCell"
    
}
