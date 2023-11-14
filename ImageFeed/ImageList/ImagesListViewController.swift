//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by Леонид Турко on 17.02.2023.
//

import UIKit

final class ImagesListViewController: UIViewController {

  //  MARK: - IB Outlets
  @IBOutlet private var tableView: UITableView!
  
  //  MARK: - Private Properties
  private let ShowSingleImageSegueIdentifier = "ShowSingleImage"
  private var photos: [Photo] = []
  private var imagesListService = ImageListService.shared
  private var alertPresenter = AlertPresenter()
  
  private lazy var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    //    formatter.dateStyle = .long
    //    formatter.timeStyle = .none
    formatter.dateFormat = "dd MMMM yyyy"
    formatter.locale = Locale(identifier: "ru_RU")
    return formatter
  }()
  
  //  MARK: - Public Properties
  override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
  
  //  MARK: - Override Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    imagesListService.fetchPhotosNextPage()
    alertPresenter.delegate = self
    
    NotificationCenter.default.addObserver(
      forName: ImageListService.didChangeNotification,
      object: nil,
      queue: .main
    ) { [weak self] _ in
      guard let self = self else { return }
      self.updateTableViewAnimated()
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == ShowSingleImageSegueIdentifier {
      guard let viewController = segue.destination as? SingleImageViewController else { return }
      guard let indexPath = sender as? IndexPath else { return }
      if let url = imagesListService.photos[indexPath.row].largeImageURL,
         let imageURL = URL(string: url) {
        viewController.singleImageURL = imageURL
      }
    } else {
      super.prepare(for: segue, sender: sender)
    }
  }
  
  private func updateTableViewAnimated() {
    let oldCount = photos.count
    let newCount = imagesListService.photos.count
    photos = imagesListService.photos
    if oldCount != newCount {
      tableView.performBatchUpdates {
        let indexPaths = (oldCount..<newCount).map { i in
          IndexPath(row: i, section: 0)
        }
        tableView.insertRows(at: indexPaths, with: .automatic)
      } completion: { _ in }
    }
  }
}

//  MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    imagesListService.photos.count
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if indexPath.row == tableView.numberOfRows(inSection: 0) - 1 {
      imagesListService.fetchPhotosNextPage()
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: ImageListCell.reuseIdentifier, for: indexPath)
    guard let imageListCell = cell as? ImageListCell else { return UITableViewCell() }
    imageListCell.delegate = self
    configCell(for: imageListCell, with: indexPath)
    return imageListCell
  }
}

//  MARK: - ImagesListCellDelegate
extension ImagesListViewController: ImagesListCellDelegate {
  func imageListCellDidTapLike(_ cell: ImageListCell) {
    guard let indexPath = tableView.indexPath(for: cell) else { return }
    let photo = photos[indexPath.row]
    UIBlockingProgressHUD.show()
    imagesListService.changeLike(photoId: photo.id, isLike: photo.isLiked) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success:
        self.photos = self.imagesListService.photos
//          defer { cell.setIsLiked(isLiked: self.photos[indexPath.row].isLiked) }
        UIBlockingProgressHUD.dismiss()
      case .failure(let error):
        UIBlockingProgressHUD.dismiss()
        self.alertPresenter.showAlert(title: "Error", message: "Something went wrong\(error)") {}
      }
    }
      cell.setIsLiked(isLiked: photos[indexPath.row].isLiked)
  }
}

//  MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    performSegue(withIdentifier: ShowSingleImageSegueIdentifier, sender: indexPath)
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let imageHeight = imagesListService.photos[indexPath.row].size.height
    let imageWidth = imagesListService.photos[indexPath.row].size.width
    
    let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
    let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
  
    let scale = imageViewWidth / imageWidth
    let cellHeight = imageHeight * scale + imageInsets.top + imageInsets.bottom
    return cellHeight
  }
}

//  MARK: -  Private Methods
extension ImagesListViewController {
  private func configCell(for cell: ImageListCell, with indexPath: IndexPath) {
    let placeholder = UIImage(named: "scribe")
    if let thumbImageURL = imagesListService.photos[indexPath.row].thumbImageURL,
       let imageURL = URL(string: thumbImageURL),
       let data = imagesListService.photos[indexPath.row].createdAt {
      cell.pictureImage.kf.indicatorType = .activity
      cell.dataLabel.text = dateFormatter.string(from: data)
      cell.pictureImage.kf.setImage(with: imageURL, placeholder: placeholder) { [weak self] _ in
        guard let self = self else { return }
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
      }
      let isLiked = imagesListService.photos[indexPath.row].isLiked == false
//      let likeImage = isLiked 
//        ? UIImage(named: "no_active")
//        : UIImage(named: "active")
//      cell.likeButton.setImage(likeImage, for: .normal)
        cell.setIsLiked(isLiked: isLiked)
//      cell.selectionStyle = .none
    }
  }
}


