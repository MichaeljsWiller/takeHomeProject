//
//  PhotoGalleryView.swift
//  TakeHomeProject
//
//  Created by Michael Willer on 14/09/2021.
//

import UIKit

/// A view responsible for displaying a collection of photos from a queried search
final class PhototGalleryView: UIViewController {
  
  // MARK: - Properties
  
  /// The view model backing this view
  var viewModel: GalleryViewModel?
  
  private var collectionView: UICollectionView!
  private var noPhotosFoundImageView: UIImageView!
  private var noPhotosFoundLabel: UILabel!
  
  // MARK: - View Lifecycle
  
  override func viewDidLoad() {
    view.backgroundColor = .backGroundColour
    setupViews()
    setupConstraints()
  }
  
  // MARK: - Setup
  
  private func setupViews() {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 1
    layout.minimumInteritemSpacing = 1
    layout.itemSize = CGSize(
      width: view.frame.width / 2,
      height: view.frame.height / 2
    )
    collectionView = UICollectionView(
      frame: .zero,
      collectionViewLayout: layout
    )
    collectionView.register(
      GalleryCollectionViewCell.self,
      forCellWithReuseIdentifier: GalleryCollectionViewCell.identifier
    )
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.backgroundColor = .backGroundColour
    view.addSubview(collectionView)
    
    let image = UIImage(named: "noRecentSearches")
    let templateImage = image?.withTintColor(.templateImageTint ?? .black)
    noPhotosFoundImageView = UIImageView()
    noPhotosFoundImageView.image = templateImage
    view.addSubview(noPhotosFoundImageView)
    
    noPhotosFoundLabel = UILabel()
    noPhotosFoundLabel.text = "Oops... No results found matching that search"
    noPhotosFoundLabel.font = .systemFont(ofSize: 15)
    noPhotosFoundLabel.textColor = .lightGray
    noPhotosFoundLabel.alpha = 0.6
    noPhotosFoundImageView.addSubview(noPhotosFoundLabel)
    
    if let viewModel = viewModel,
       viewModel.galleryItem.galleryPhotos.isEmpty {
      noPhotosFoundImageView.isHidden = false
      noPhotosFoundLabel.isHidden = false
    } else {
      noPhotosFoundImageView.isHidden = true
      noPhotosFoundLabel.isHidden = true
    }
  }
  
  private func setupConstraints() {
    collectionView.anchor(
      top: view.topAnchor,
      bottom: view.bottomAnchor,
      leading: view.leadingAnchor,
      trailing: view.trailingAnchor
      )
    
    noPhotosFoundImageView.contentMode = .scaleAspectFit
    noPhotosFoundImageView.anchor(
      leading: view.leadingAnchor,
      paddingLeft: 15,
      trailing: view.trailingAnchor,
      paddingRight: 20,
      centerY: view.safeAreaLayoutGuide.centerYAnchor
    )
    
    noPhotosFoundLabel.anchor(
      centerX: view.safeAreaLayoutGuide.centerXAnchor,
      centerY: view.safeAreaLayoutGuide.centerYAnchor,
      height: 20)
  }
}

// MARK: - UICollectionViewDelegate Methods
extension PhototGalleryView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard let viewModel = viewModel else { return 0 }
    
    return viewModel.galleryItem.galleryPhotos.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let thumbnailURL = viewModel?.galleryItem.galleryPhotos[indexPath.row].thumbnailImageURL
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCollectionViewCell.identifier, for: indexPath) as! GalleryCollectionViewCell
    cell.populateCell(with: thumbnailURL!)
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: (collectionView.frame.size.width / 3) - 3,
                  height: (collectionView.frame.size.height / 6))
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let selectedImageURL = viewModel?.galleryItem.galleryPhotos[indexPath.row].imageURL else { return }
    viewModel?.viewFullImage(using: selectedImageURL)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
  }
}
