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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
