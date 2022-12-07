//
//  URLSessionMock.swift
//  TakeHomeProject
//
//  Created by Michael Willer on 15/09/2021.
//

import UIKit
import Combine

/// A class representing a mock URLSession object
class StubURLSession: DataTaskProtocol {
  
  /// The url of the request to be sent
  var cachedURL: URL?
  /// whether a cached image was returned set to false upone method call
  var returnedCachedImage = true
  
  /// Mocks url data task request and creates a mock response
  func dataTaskResponse(for url: URL) -> AnyPublisher<Response, URLError> {
    self.returnedCachedImage = false
    self.cachedURL = url
    // Get image data to return in response body
    let imageData = UIImage(systemName: "video")?.jpegData(compressionQuality: 1)
    
    let response = HTTPURLResponse(
      url: url,
      statusCode: 200,
      httpVersion: "HTTP/1.1",
      headerFields: ["": ""])!
    return Result.success((data: imageData!, response: response)).publisher
      .setFailureType(to: URLError.self)
      .eraseToAnyPublisher()
  }
  
}
