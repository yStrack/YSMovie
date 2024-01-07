//
//  MovieListEndpoint.swift
//  YSMovie
//
//  Created by ystrack on 07/01/24.
//

import Foundation

public enum MovieListEndpoint: Endpoint {
    case nowPlaying
    case popular
    case topRated
    case upcoming
    
    public var baseURL: URL {
        return URL(string: "https://api.themoviedb.org/3/movie")!
    }
    
    public var path: String {
        switch self {
        case .nowPlaying:
            "/now_playing"
        case .popular:
            "/popular"
        case .topRated:
            "/top_rated"
        case .upcoming:
            "/upcoming"
        }
    }
    
    public var method: HTTPMethod {
        return .get
    }
    
    public var headers: [String : String]? {
        return ["Authorization" : "Bearer \(SECRETS.API_ACCESS_TOKEN)"]
    }
    
    public var parameters: [String : String]? {
        return [
            "language": Locale.preferredLanguages[0],
            "page": "\(1)"
        ]
    }
    
    public var body: [String : String]? {
        nil
    }
}
