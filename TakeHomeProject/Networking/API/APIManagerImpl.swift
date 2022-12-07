//
//  APIManager.swift
//  TakeHomeProject
//
//  Created by Michael Willer on 14/09/2021.
//

import Foundation
import Combine

protocol APIManager {
  
  func retrieveSearchResults<T: Codable>(
    from endpoint: Endpoint,
    using query: String
  ) -> AnyPublisher<T, Error>?
}

/// Manager class responsibe for sending and recieving requests from an API
final class APIManagerImpl: APIManager {
  
  // MARK: - Properties
  
  private let session: DataTaskProtocol
  
  // MARK: - Init
  
  init(session: DataTaskProtocol = URLSession.shared) {
    self.session = session
  }
  
  // MARK: - Internal Methods
  
  /// Retrieves a list of search results from the given endpoint
  /// - Parameters:
  ///   - endpoint: The endpoint that the request is for
  ///   - query: The search query to be sent within the request
  /// - Returns: A Publisher that emits the response from the API
  func retrieveSearchResults<T: Codable>(
    from endpoint: Endpoint,
    using query: String
  ) -> AnyPublisher<T, Error>? {
    guard let token = endpoint.key else { return nil }
    
    var component = URLComponents(string: endpoint.baseUrl + endpoint.path)
    component?.queryItems = [
      URLQueryItem(name: "key", value: token),
      URLQueryItem(name: "q", value: query.replacingOccurrences(of: " ", with: "+")),
      URLQueryItem(name: "safesearch", value: "true"),
      URLQueryItem(name: "per_page", value: "200")
    ]
    
    guard let url = component?.url else { return nil }
    return session.dataTaskResponse(for: url)
      .map { $0.data }
      .decode(type: T.self, decoder: JSONDecoder())
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()
  }
}
