//
//  ReleaseDate.swift
//  YSMovie
//
//  Created by ystrack on 12/01/24.
//

import Foundation

struct ReleaseDateResult: Decodable {
    let iso_3166_1: String
    let release_dates: [ReleaseDate]
}

struct ReleaseDate: Decodable {
    /// Age rating
    let certification: String?
    let descriptors: [String]?
    let iso_639_1: String?
    let note: String?
    let release_date: String?
    let type: Int?
}
