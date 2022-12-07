//
//  GalleryVideo.swift
//  TakeHomeProject
//
//  Created by Michael Willer on 14/09/2021.
//

import Foundation

/// A Class which represents a video
final class GalleryVideo {
  /// The unique identifier of the image
  let id: Int
  /// The url for the thumbnail image
  let thumbnailImageURL: String
  /// The url for a small video
  let smallVideoURL: URL?
  /// The url for a medium video
  let mediumVideoURL: URL?
  /// The url for a large video
  let largeVideoURL: URL?
  /// The duration of the video
  let duration: Int
  
  init(
    id: Int,
    thumbnailImage: String,
    smallVideoURL: URL?,
    mediumVideoURL: URL?,
    largeVideoURL: URL?,
    duration: Int
  ) {
    self.id = id
    self.thumbnailImageURL = thumbnailImage
    self.smallVideoURL = smallVideoURL
    self.mediumVideoURL = mediumVideoURL
    self.largeVideoURL = largeVideoURL
    self.duration = duration
  }
}
