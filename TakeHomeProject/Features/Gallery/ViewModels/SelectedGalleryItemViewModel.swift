//
//  SelectedPhotoViewModel.swift
//  TakeHomeProject
//
//  Created by Michael Willer on 15/09/2021.
//

import UIKit
import Combine

/// ViewModel backing the selected photo and video views
final class SelectedGalleryItemViewModel {
  
  // MARK: - Properties
  
  /// Handles navigation between views
  weak var coordinator: Coordinator?
  
  /// The URL for a full sized version of a selected image or video
  let galleryItemURL: URL
  
  private var cancellables = Set<AnyCancellable>()
  
  // MARK: - Initialiser
  
  init(galleryItemURL: URL) {
    self.galleryItemURL = galleryItemURL
  }
  
  // MARK: - Internal Methods
  
  /// Loads an image from a URL
  func loadImage(completion: @escaping (_ image: UIImage?) -> Void) {
    CacheManager.shared.downloadImage(from: galleryItemURL)
      .replaceError(with: UIImage())
      .sink { image in
        completion(image)
      }
      .store(in: &cancellables)
  }
}
