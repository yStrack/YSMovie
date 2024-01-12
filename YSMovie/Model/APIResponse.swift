//
//  APIResponse.swift
//  YSMovie
//
//  Created by ystrack on 07/01/24.
//

import Foundation

/// TMDB API Response data model for Movie related endpoints.
struct APIResponse<ResultType: Decodable>: Decodable {
    let page: Int?
    let results: [ResultType]
    let total_pages: Int?
    let total_results: Int?
}
