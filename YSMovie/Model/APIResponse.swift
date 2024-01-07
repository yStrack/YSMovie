//
//  APIResponse.swift
//  YSMovie
//
//  Created by ystrack on 07/01/24.
//

import Foundation

/// TMDB API Response data model for Movie related endpoints.
struct APIResponse: Decodable {
    let page: Int
    let results: [Movie]
    let total_pages: Int
    let total_results: Int
}
