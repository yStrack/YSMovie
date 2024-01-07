//
//  Endpoint.swift
//  YSMovie
//
//  Created by ystrack on 07/01/24.
//

import Foundation

/// Protocol to setup all Endpoints
public protocol Endpoint {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var parameters: [String: String]? { get }
    var body: [String: String]? { get }
}
