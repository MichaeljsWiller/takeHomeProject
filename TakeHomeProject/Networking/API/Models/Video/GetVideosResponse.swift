//
//  GetVideosResponse.swift
//  TakeHomeProject
//
//  Created by Michael Willer on 14/09/2021.
//

import Foundation

/// Represents a response from an api when a get videos request has been successful
struct GetVideoResponse: Codable {
  let hits: [VideoHit]
}
