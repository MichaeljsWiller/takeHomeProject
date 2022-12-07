//
//  GalleryViewModel.swift
//  TakeHomeProject
//
//  Created by Michael Willer on 14/09/2021.
//

import Foundation

/// ViewModel backing the photo gallery view
final class GalleryViewModel {
  
  // MARK: - Properties
  
  /// Handles navigation between views
  weak var coordinator: Coordinator?
  /// A gallery item containing a list of photos and videos
  var galleryItem: SearchItem
  
  // MARK: - Initialiser
  
  init(
    galleryItem: SearchItem,
    coordinator: Coordinator? = nil
  ) {
    self.galleryItem = galleryItem
    self.coordinator = coordinator
  }
  
  // MARK: - Internal Methods
  
  /// Opens the selected image into its full size
  func viewFullImage(using url: URL) {
    coordinator?.navigateToSelectedImageView(using: url)
  }
  
  /// Opens the video selected to its full size and begins video playback
  func playSelectedVideo(using url: URL) {
    coordinator?.navigateToSelectedVideoView(using: url)
  }
}
