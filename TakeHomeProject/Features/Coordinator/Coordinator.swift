//
//  Coordinator.swift
//  TakeHomeProject
//
//  Created by Michael Willer on 13/09/2021.
//

import UIKit

protocol Coordinator: AnyObject {
  func start()
  func navigateToGallery(with media: SearchItem)
  func navigateToSelectedImageView(using url: URL)
  func navigateToSelectedVideoView(using url: URL)
  func showErrorAlert()
}

/// Class responsible for handling navigation between views
final class CoordinatorImpl: Coordinator {

  // MARK: - Properties
  
  private let window: UIWindow
  private let navigationController = UINavigationController()
  
  // MARK: - Initialiser
  
  init(window: UIWindow) {
    self.window = window
  }
  
  // MARK: - Internal Methods
  
  /// Begins application and sets up the root view controller
  func start() {
    let searchVC = SearchView()
    let searchVM = SearchViewModel()
    searchVM.delegate = searchVC
    searchVM.coordinator = self
    searchVC.viewModel = searchVM
    navigationController.pushViewController(searchVC, animated: false)
    window.rootViewController = navigationController
    window.makeKeyAndVisible()
  }
  
  /// Pushes to a gallery view with an embedded tab bar for both photo and video selection
  func navigateToGallery(with media: SearchItem) {
    let tabBarController = UITabBarController()
    
    let photoGalleryVC = PhototGalleryView()
    let galleryVM = GalleryViewModel(galleryItem: media)
    galleryVM.coordinator = self
    photoGalleryVC.viewModel = galleryVM
    
    let videoGalleryVC = VideoGalleryView()
    videoGalleryVC.viewModel = galleryVM
    
    let photoItem = UITabBarItem()
    photoItem.title = "Photos"
    photoItem.image = UIImage(systemName: "photo")
    let videoItem = UITabBarItem()
    videoItem.title = "Videos"
    videoItem.image = UIImage(systemName: "video")
    
    photoGalleryVC.tabBarItem = photoItem
    videoGalleryVC.tabBarItem = videoItem
    tabBarController.viewControllers = [photoGalleryVC, videoGalleryVC]
    tabBarController.navigationItem.title = media.searchTitle
    
    tabBarController.willMove(toParent: self.navigationController)
    navigationController.pushViewController(tabBarController, animated: false)
    tabBarController.didMove(toParent: navigationController)
  }
  
  /// Pushes to the selected image view displaying the image in full screen
  func navigateToSelectedImageView(using url: URL) {
    let selectedPhotoView = SelectedPhotoView()
    let selectedPhotoViewViewModel = SelectedGalleryItemViewModel(galleryItemURL: url)
    selectedPhotoViewViewModel.coordinator = self
    selectedPhotoView.viewModel = selectedPhotoViewViewModel
    navigationController.pushViewController(selectedPhotoView, animated: true)
  }
  
  /// Pushes to the selected video view displaying the video in full screen for playback
  func navigateToSelectedVideoView(using url: URL) {
    let selectedVideoView = SelectedVideoView()
    let selectedVideoViewModel =  SelectedGalleryItemViewModel(galleryItemURL: url)
    selectedVideoViewModel.coordinator = self
    selectedVideoView.viewModel = selectedVideoViewModel
    navigationController.pushViewController(selectedVideoView, animated: true)
  }
  
  /// Displays an error alert message for when a query is invalid
  func showErrorAlert() {
    let alert = UIAlertController(title: "Error", message: "Oops.. It looks like that image cannot be found", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
    navigationController.present(alert, animated: true)
  }
}
