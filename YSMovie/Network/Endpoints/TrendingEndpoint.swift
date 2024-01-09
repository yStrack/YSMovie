//
//  TrendingEndpoint.swift
//  YSMovie
//
//  Created by ystrack on 08/01/24.
//

import Foundation

enum TrendingEndpoint: Endpoint {
    case movie
    
    var baseURL: URL {
        return URL(string: "https://api.themoviedb.org/3/trending")!
    }
    
    var path: String {
        return "/movie/day"
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var headers: [String : String]? {
        return ["Authorization" : "Bearer \(SECRETS.API_ACCESS_TOKEN)"]
    }
    
    var parameters: [String : String]? {
        return [
            "language": Locale.preferredLanguages[0]
        ]
    }
    
    var body: [String : String]? {
        return nil
    }
}
