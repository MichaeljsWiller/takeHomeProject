//
//  VideoSize.swift
//  TakeHomeProject
//
//  Created by Michael Willer on 05/12/2022.
//

import Foundation

/// Represents a video size and its properties
struct VideoSize: Codable {
  let large: VideoProperties
  let medium: VideoProperties
  let small: VideoProperties
  let tiny: VideoProperties
}
