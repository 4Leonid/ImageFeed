//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by Леонид Турко on 17.02.2023.
//

import UIKit

protocol ImagesListViewControllerProtocol: AnyObject {
    func update(photos: [Photo])
}

final class ImagesListViewController: UIViewController {

    //  MARK: - IB Outlets
    @IBOutlet private var tableView: UITableView!

    //  MARK: - Private Properties
    private let ShowSingleImageSegueIdentifier = "ShowSingleImage"
    private var alertPresenter = AlertPresenter()

    var presenter: ImagesListViewPresenterProtocol?


    //  MARK: - Public Properties
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    //  MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        presenter?.viewDidLoad()
        alertPresenter.delegate = self
    }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == ShowSingleImageSegueIdentifier {
      guard let viewController = segue.destination as? SingleImageViewController else { return }
      let imagesListService = ImageListService.shared
      guard let indexPath = sender as? IndexPath else { return }
      if let url = imagesListService.photos[indexPath.row].largeImageURL,
         let imageURL = URL(string: url) {
        viewController.singleImageURL = imageURL
      }
    } else {
      super.prepare(for: segue, sender: sender)
    }
  }
}

//  MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      guard let presenter = presenter else {
          preconditionFailure("presenter not configures")
      }
      return presenter.photos.count
  }
  
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: 0) - 1, let presenter = presenter {
            presenter.tableViewExceed()
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

//  MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    performSegue(withIdentifier: ShowSingleImageSegueIdentifier, sender: indexPath)
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    guard let presenter = presenter else {
      return .zero
    }
    let imageHeight = presenter.photos[indexPath.row].size.height
    let imageWidth = presenter.photos[indexPath.row].size.width
    
    let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
    let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
    let scale = imageViewWidth / imageWidth
    let cellHeight = imageHeight * scale + imageInsets.top + imageInsets.bottom
    return cellHeight
  }
}

//  MARK: - ImagesListCellDelegate
extension ImagesListViewController: ImagesListCellDelegate {
  func imageListCellDidTapLike(_ cell: ImageListCell) {
    guard let presenter = presenter, let indexPath = tableView.indexPath(for: cell) else { return }
    UIBlockingProgressHUD.show()
    presenter.changeLike(for: indexPath) {
      cell.setIsLiked(isLiked: !presenter.photos[indexPath.row].isLiked)
    }
  }
}


//  MARK: -  Private Methods
extension ImagesListViewController {
    private func configCell(for cell: ImageListCell, with indexPath: IndexPath) {
        guard let presenter = presenter else {
            return
        }
        let placeholder = UIImage(named: "scribe")
        if let thumbImageURL = presenter.photos[indexPath.row].thumbImageURL,
           let imageURL = URL(string: thumbImageURL),
           let data = presenter.photos[indexPath.row].createdAt {
            cell.pictureImage.kf.indicatorType = .activity
          cell.dataLabel.text = presenter.timeSetup(data)//dateFormatter.string(from: data)
            cell.pictureImage.kf.setImage(with: imageURL, placeholder: placeholder) { [weak self] _ in
                guard let self = self else { return }
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            let isLiked = presenter.photos[indexPath.row].isLiked == false
            cell.setIsLiked(isLiked: isLiked)
        }
    }
}

//  MARK: -  ImagesListViewControllerProtocol
extension ImagesListViewController: ImagesListViewControllerProtocol {
  func update(photos: [Photo]) {
    tableView.performBatchUpdates {
      let indexPaths = (tableView.numberOfRows(inSection: 0)..<photos.count).map { i in
        IndexPath(row: i, section: 0)
      }
      tableView.insertRows(at: indexPaths, with: .automatic)
    }
  }
}
