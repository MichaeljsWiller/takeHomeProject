//
//  ImageCacheManager.swift
//  TakeHomeProject
//
//  Created by Michael Willer on 15/09/2021.
//

import UIKit
import Combine

/// Manages caching objects and retriving cached objects
final class CacheManager {
  
  // MARK: - Properties
  
  /// The shared singleton manager object
  static let shared = CacheManager()
  /// A collection of stored images and their associated keys
  let imageCache = NSCache<NSString, UIImage>()
  
  private let session: DataTaskProtocol
  private var cancellables = Set<AnyCancellable>()
  
  // MARK: - Init
  
  init(session: DataTaskProtocol = URLSession.shared) {
    self.session = session
    observeMemory()
  }
  
  // MARK: - Internal Methods

  /// Downloads an image from a given URL and caches the image
  /// - Parameter url: The URL to download the image from
  /// - Returns: Returns a cached image if one is already stored for the given url
  ///   otherwise returns the downloaded image or an error if failure occurs
  func downloadImage(from url: URL) -> AnyPublisher<UIImage, URLError> {
    if let cachedimage = imageCache.object(forKey: url.absoluteString as NSString) {
      return Future<UIImage, URLError> { promise in
        promise(.success(cachedimage))
      }.eraseToAnyPublisher()
    } else {
      return session.dataTaskResponse(for: url)
        .compactMap( { UIImage(data: $0.data) } )
        .receive(on: DispatchQueue.main)
        .handleEvents( receiveOutput: {
          self.imageCache.setObject($0, forKey: url.absoluteString as NSString)
        })
        .eraseToAnyPublisher()
    }
  }
  
  // MARK: - Private Methods
  
  private func clearCache() {
    imageCache.removeAllObjects()
  }
  
  private func observeMemory() {
    NotificationCenter.default.publisher(for: UIApplication.didReceiveMemoryWarningNotification)
      .receive(on: DispatchQueue.main)
      .sink { _ in
        self.clearCache()
      }
      .store(in: &cancellables)
  }
}

// MARK: - Errors

enum CachError: Error {
  /// An error indicating the the given url is invalid
  case invalidURL
}
