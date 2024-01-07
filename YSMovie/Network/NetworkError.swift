//
//  NetworkError.swift
//  YSMovie
//
//  Created by ystrack on 07/01/24.
//

import Foundation

/// Custom Network Errors.
public enum NetworkError: Error {
    /// Response error is not nil.
    case invalidResponse
    /// API responded with a failure status code (Outside range 200...299).
    case unexpectedStatusCode
    /// Failed to decode response Data.
    case unableToParse
    /// Something unknown went wrong while fetching API data.
    case unknown
}
