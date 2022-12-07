//
//  PixabayEndpoint.swift
//  TakeHomeProject
//
//  Created by Michael Willer on 06/12/2022.
//

import Foundation

/// Represents an enpoint to the Pixabay.com API
enum PixabayEndpoint: Endpoint {
  case searchVideos
  case searchPhotos
  
  var baseUrl: String {
    return "https://pixabay.com/api/"
  }
  
  var path: String {
    switch self {
    case .searchVideos:
      return "videos/"
    case .searchPhotos:
      return ""
    }
  }
  
  var key: String? {
    return Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String
  }
}
