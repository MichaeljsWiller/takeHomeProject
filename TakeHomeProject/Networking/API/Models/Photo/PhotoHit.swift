//
//  PhotoHit.swift
//  TakeHomeProject
//
//  Created by Michael Willer on 05/12/2022.
//

import Foundation

/// Represents an image accessed through the api and its information
struct PhotoHit: Codable {
  /// The id of the image
  let id: Int
  /// The url for the large sclaed version of the image
  let largeImageURL: URL
  /// the url for the small scaled preview version of the image
  let previewURL: URL
}
