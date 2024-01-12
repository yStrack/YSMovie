//
//  MovieEndpoint.swift
//  YSMovie
//
//  Created by ystrack on 12/01/24.
//

import Foundation

enum MovieEndpoint: Endpoint {
    case details(movieId: Int)
    
    var baseURL: URL {
       return URL(string: "https://api.themoviedb.org/3/movie")!
    }
    
    var path: String {
        switch self {
        case .details(let movieId):
            return "\(movieId)"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var headers: [String : String]? {
        return ["Authorization" : "Bearer \(SECRETS.API_ACCESS_TOKEN)"]
    }
    
    var parameters: [String : String]? {
        switch self {
        case .details(_):
            return [
                "append_to_response": "videos,similar,release_dates",
                "language": Locale.preferredLanguages[0]
            ]
        }
    }
    
    var body: [String : String]? {
        return nil
    }
}
