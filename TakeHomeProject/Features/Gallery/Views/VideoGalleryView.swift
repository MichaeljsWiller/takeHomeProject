//
//  VideoGalleryView.swift
//  TakeHomeProject
//
//  Created by Michael Willer on 14/09/2021.
//

import UIKit

/// A view responsible for displaying a collection of videos from a queried search
final class VideoGalleryView: UIViewController {
  
  // MARK: - Properties
  
  /// The view model backing this view
  var viewModel: GalleryViewModel?
  
  private var collectionView: UICollectionView!
  private var noVideosFoundImageView: UIImageView!
  private var noVideosFoundLabel: UILabel!
  
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
    noVideosFoundImageView = UIImageView()
    noVideosFoundImageView.image = templateImage
    view.addSubview(noVideosFoundImageView)
    
    noVideosFoundLabel = UILabel()
    noVideosFoundLabel.text = "Oops... No results found matching that search"
    noVideosFoundLabel.font = .systemFont(ofSize: 15)
    noVideosFoundLabel.textColor = .lightGray
    noVideosFoundLabel.alpha = 0.6
    noVideosFoundImageView.addSubview(noVideosFoundLabel)
    
    if let viewModel = viewModel,
       viewModel.galleryItem.galleryVideos.isEmpty {
      noVideosFoundImageView.isHidden = false
      noVideosFoundLabel.isHidden = false
    } else {
      noVideosFoundImageView.isHidden = true
      noVideosFoundLabel.isHidden = true
    }
  }
  
  private func setupConstraints() {
    collectionView.anchor(
      top: view.topAnchor,
      bottom: view.bottomAnchor,
      leading: view.leadingAnchor,
      trailing: view.trailingAnchor
    )
    
    noVideosFoundImageView.contentMode = .scaleAspectFit
    noVideosFoundImageView.anchor(
      leading: view.leadingAnchor,
      paddingLeft: 15,
      trailing: view.trailingAnchor,
      paddingRight: 20,
      centerY: view.safeAreaLayoutGuide.centerYAnchor
    )
    
    noVideosFoundLabel.anchor(
      centerX: view.safeAreaLayoutGuide.centerXAnchor,
      centerY: view.safeAreaLayoutGuide.centerYAnchor,
      height: 20)
  }
}

// MARK: - UICollectionViewDelegate Methods
extension VideoGalleryView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard let viewModel = viewModel else { return 0 }
    return viewModel.galleryItem.galleryVideos.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let viewModel = viewModel else { return UICollectionViewCell() }
    let thumbnailURL = viewModel.galleryItem.galleryVideos[indexPath.row].thumbnailImageURL
    let urlString = "https://i.vimeocdn.com/video/" + thumbnailURL + "_295x166.jpg"
    if let url = URL(string: urlString) {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCollectionViewCell.identifier,
                                                    for: indexPath) as! GalleryCollectionViewCell
      let videoDuration = viewModel.galleryItem.galleryVideos[indexPath.row].duration
      let durationAsString = videoDuration < 10 ? "0" + String(videoDuration) : String(videoDuration)
      cell.populateCell(with: url, duration: "0:" + String(durationAsString))
      return cell
    }
    return UICollectionViewCell()
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return CGSize(width: (collectionView.frame.size.width / 3) - 3,
                  height: (collectionView.frame.size.height / 6))
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let selectedVideoURL = viewModel?.galleryItem.galleryVideos[indexPath.row].mediumVideoURL else { return }
    viewModel?.playSelectedVideo(using: selectedVideoURL)
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAt section: Int
  ) -> UIEdgeInsets {
    return UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
  }
}
