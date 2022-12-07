//
//  GetPhotosResponse.swift
//  TakeHomeProject
//
//  Created by Michael Willer on 14/09/2021.
//

import Foundation

/// Represents a response from an api when a get photos request has been successful
struct GetPhotosResponse: Codable {
  /// A list of images and their details recieved from the search query with
  let hits: [PhotoHit]
}
