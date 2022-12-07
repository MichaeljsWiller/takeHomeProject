//
//  DataTaskProtocol.swift
//  TakeHomeProject
//
//  Created by Michael Willer on 15/09/2021.
//

import Foundation
import Combine

/// Protocol that allows mocking of Data Task Publishers
protocol DataTaskProtocol {
  typealias Response = URLSession.DataTaskPublisher.Output
  
  func dataTaskResponse(for url: URL) -> AnyPublisher<Response, URLError>
}

extension URLSession: DataTaskProtocol {
  /// Returns a publisher that wraps a URLSession data task for a given request
  func dataTaskResponse(for url: URL) -> AnyPublisher<(Response), URLError> {
    return dataTaskPublisher(for: url).eraseToAnyPublisher()
  }
}
