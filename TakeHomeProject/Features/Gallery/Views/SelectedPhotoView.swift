//
//  SelectedPhotoView.swift
//  TakeHomeProject
//
//  Created by Michael Willer on 15/09/2021.
//

import UIKit
import Combine

/// A view displaying a full sized photo
final class SelectedPhotoView: UIViewController {
  
  // MARK: - Properties
  
  /// The view model backing this view
  var viewModel: SelectedGalleryItemViewModel?
  
  private var imageView: UIImageView!
  private var loadingIndicator: UIActivityIndicatorView!
  
  // MARK: - View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .backGroundColour
    setupView()
    layoutView()
    getImage()
    loadingIndicator.startAnimating()
  }
  
  // MARK: - Setup
  
  private func setupView() {
    imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.clipsToBounds = true
    imageView.layer.cornerRadius = 12
    view.addSubview(imageView)
    
    loadingIndicator = UIActivityIndicatorView(style: .large)
    loadingIndicator.hidesWhenStopped = true
    view.addSubview(loadingIndicator)
  }
  
  private func layoutView() {
    imageView.anchor(
      top: view.topAnchor,
      bottom: view.bottomAnchor,
      leading: view.leadingAnchor,
      trailing: view.trailingAnchor
    )
    
    loadingIndicator.anchor(
      centerX: view.safeAreaLayoutGuide.centerXAnchor,
      centerY: view.safeAreaLayoutGuide.centerYAnchor
    )
  }
  
  // MARK: - Private Methods
  
  private func getImage() {
    viewModel?.loadImage(completion: { [weak self] image in
      DispatchQueue.main.async {
        self?.imageView.image = image
        self?.loadingIndicator.stopAnimating()
      }
    })
  }
}
