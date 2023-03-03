//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by Леонид Турко on 17.02.2023.
//

import UIKit

class ImagesListViewController: UIViewController {
  //  MARK: - IB Outlets
  @IBOutlet private var tableView: UITableView!
  
  //  MARK: - Private Properties
  private let photosName: [String] = (0..<20).map { "\($0)" }
  private let ShowSingleImageSegueIdentifier = "ShowSingleImage"
  
  private lazy var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .none
    return formatter
  }()
  
  override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
  
  //  MARK: - Override Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == ShowSingleImageSegueIdentifier {
      guard let viewController = segue.destination as? SingleImageViewController else { return }
      guard let indexPath = sender as? IndexPath else { return }
      let image = UIImage(named: photosName[indexPath.row])
      viewController.image = image
    } else {
      super.prepare(for: segue, sender: sender)
    }
  }
}

//  MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    photosName.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: ImageListCell.reuseIdentifier, for: indexPath)
    guard let imageListCell = cell as? ImageListCell else { return UITableViewCell() }
    
    configCell(for: imageListCell, with: indexPath)
    return imageListCell
  }
}

//  MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    performSegue(withIdentifier: ShowSingleImageSegueIdentifier, sender: indexPath)
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    guard let image = UIImage(named: photosName[indexPath.row]) else { return 0 }
    
    let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
    let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
    let imageWidth = image.size.width
    let scale = imageViewWidth / imageWidth
    let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
    return cellHeight
  }
}

//  MARK: -  Private Methods
extension ImagesListViewController {
  private func configCell(for cell: ImageListCell, with indexPath: IndexPath) {
    guard let image = UIImage(named: photosName[indexPath.row]) else { return }
    cell.pictureImage.image = image
    cell.dataLabel.text = dateFormatter.string(from: Date())
    let isLiked = indexPath.row % 2 == 0
    let likeImage = isLiked
    ? UIImage(named: "like_button_on")
    : UIImage(named: "like_button_off")
    cell.likeButton.setImage(likeImage, for: .normal)
    
  }
}


