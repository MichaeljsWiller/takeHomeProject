//
//  Endpoint.swift
//  TakeHomeProject
//
//  Created by Michael Willer on 14/09/2021.
//

import Foundation

/// Represents an enpoint for a resource of an API
protocol Endpoint {
  var baseUrl: String { get }
  var path: String { get }
  var key: String? { get }
}
