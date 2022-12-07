//
//  GalleryPhoto.swift
//  TakeHomeProject
//
//  Created by Michael Willer on 14/09/2021.
//

import Foundation

/// A Class which represents a photo
final class GalleryPhoto {
  /// The unique identifier of the image
  let id: Int
  /// The url for the thumbnail image
  let thumbnailImageURL: URL
  /// The url for the full sized image
  let imageURL: URL
  
  init(id: Int, thumbnailImage: URL, image: URL) {
    self.id = id
    self.thumbnailImageURL = thumbnailImage
    self.imageURL = image
  }
}
