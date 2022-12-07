//
//  VideoHit.swift
//  TakeHomeProject
//
//  Created by Michael Willer on 05/12/2022.
//

import Foundation

/// Represents a video response and all its properties
struct VideoHit: Codable {
  /// The id of the video
  let id: Int
  /// the length of the video
  let duration: Int
  /// The id for a thumnail image of the video
  let pictureId: String
  /// A video with different sizes
  let videos: VideoSize
  
  private enum CodingKeys: String, CodingKey {
    case id
    case duration
    case pictureId = "picture_id"
    case videos
  }
}
