//
//  StubAPIManager.swift
//  TakeHomeProjectTests
//
//  Created by Michael Willer on 05/12/2022.
//

import Foundation
import Combine
@testable import TakeHomeProject

/// A class representing a mock APIManager object for the Pixabay endpoint
final class StubPixabayAPIMAnager: APIManager {
  
  var simulatedPhotoResult: Result<GetPhotosResponse, Error>?
  var simulatedVideoResult: Result<GetVideoResponse, Error>?
  
  func retrieveSearchResults<T: Codable>(
    from endpoint: Endpoint,
    using query: String
  ) -> AnyPublisher<T, Error>? {
    guard let endpoint = endpoint as? PixabayEndpoint else { return nil }
    return Future<T, Error> { [weak self] promise in
      switch endpoint {
      case .searchVideos:
        if let result = self?.simulatedVideoResult as? Result<T, Error> {
          promise(result)
        }
      case .searchPhotos:
        if let result = self?.simulatedPhotoResult as? Result<T, Error> {
          promise(result)
        }
      }
    }
    .eraseToAnyPublisher()
  }
}
