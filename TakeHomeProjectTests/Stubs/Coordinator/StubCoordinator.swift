//
//  StubCoordinator.swift
//  TakeHomeProjectTests
//
//  Created by Michael Willer on 05/12/2022.
//

import Foundation
@testable import TakeHomeProject

/// A class representing a mock Coordinator
class StubCoordinator: Coordinator {
  var navigateToGallerySearchItem: SearchItem?
  var navigateToSelectedImageViewURL: URL?
  var navigateToSelectedVideoViewURL: URL?
  
  var startCallCount = 0
  var navigateToGalleryCallCount = 0
  var navigateToSelectedImageViewCallCount = 0
  var navigateToSelectedVideoViewCallCount = 0
  var showErrorAlertCallCount = 0
  
  func start() {
    startCallCount += 1
  }
  
  func navigateToGallery(with media: SearchItem) {
    navigateToGallerySearchItem = media
    navigateToGalleryCallCount += 1
  }
  
  func navigateToSelectedImageView(using url: URL) {
    navigateToSelectedImageViewURL = url
    navigateToSelectedImageViewCallCount += 1
  }
  
  func navigateToSelectedVideoView(using url: URL) {
    navigateToSelectedVideoViewURL = url
    navigateToSelectedVideoViewCallCount += 1
  }
  
  func showErrorAlert() {
    showErrorAlertCallCount += 1
  }
}
