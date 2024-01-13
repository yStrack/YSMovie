//
//  Movie.swift
//  YSMovie
//
//  Created by ystrack on 07/01/24.
//

import Foundation

// MARK: - Movie
struct Movie: Decodable, Hashable {
    /// Used to Identify this Item on a Collection View.
    /// This way same Movies have different IDs and avoid visual inconsistencies.
    let viewId: String = UUID().uuidString
    let adult: Bool
    let backdropPath: String?
    let budget: Int?
    let genresIds: [Int]?
    let genres: [Genre]?
    let homepage: String?
    let id: Int
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let popularity: Double
    let posterPath: String?
    let productionCompanies: [ProductionCompany]?
    let productionCountries: [ProductionCountry]?
    let releaseDate: String
    let revenue, runtime: Int?
    let spokenLanguages: [SpokenLanguage]?
    let status: String?
    let tagline: String?
    let title: String
    let video: Bool
    // Appending results properties
    private let videos: APIResponse<Video>?
    private let similar: APIResponse<Movie>?
    private let releaseDates: APIResponse<ReleaseDate>?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case budget, genres, homepage, id
        case genresIds = "genres_ids"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case revenue, runtime
        case spokenLanguages = "spoken_languages"
        case status, tagline, title, video
        case videos, similar
        case releaseDates = "release_dates"
    }
    
    // MARK: Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(viewId)
    }
    
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        lhs.viewId == rhs.viewId
    }
    
    // MARK: Helpers
    /// Get the release date year.
    /// Ignoring day and month from release date.
    /// - Returns: Year as string.
    func getReleaseYear() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard
            let date = formatter.date(from: self.releaseDate),
            let year = Calendar.current.dateComponents([.year], from: date).year
        else {
            return ""
        }
        return String(year)
    }
    
    /// Get Movie runtime in hours + minutes instead of received runtime in minutes from API.
    /// - Returns: Hour + minute runtime string.
    func runtimeHourAndMinute() -> String? {
        guard let minutesRuntime = self.runtime else {
            return nil
        }
        
        return "\(minutesRuntime / 60)h \(minutesRuntime % 60)min"
    }
    
    /// Get Movie age rating (certification) for User's device location.
    /// - Returns: Age rating string.
    func getAgeRating() -> String? {
        guard let responseReleaseDates = self.releaseDates else { return nil }
        let locationId = Locale.current.region?.identifier
        return responseReleaseDates.results.first(where: { $0.iso_639_1 == locationId })?.certification
    }
    
    /// Get Movie related videos/
    /// - Returns: Videos array.
    func getVideos() -> [Video]? {
        guard let responseVideos = self.videos else { return nil }
        return responseVideos.results
    }
    
    /// Get a list of similar movies.
    /// - Returns: Similar list of Movies.
    func geSimilars() -> [Movie]? {
        guard let responseSimilar = self.similar else { return nil }
        return responseSimilar.results
    }
}

// MARK: - Genre
struct Genre: Codable {
    let id: Int
    let name: String
}

// MARK: - ProductionCompany
struct ProductionCompany: Codable {
    let id: Int
    let logoPath: String?
    let name: String?
    let originCountry: String?

    enum CodingKeys: String, CodingKey {
        case id
        case logoPath = "logo_path"
        case name
        case originCountry = "origin_country"
    }
}

// MARK: - ProductionCountry
struct ProductionCountry: Codable {
    let iso3166_1, name: String?

    enum CodingKeys: String, CodingKey {
        case iso3166_1 = "iso_3166_1"
        case name
    }
}

// MARK: - SpokenLanguage
struct SpokenLanguage: Codable {
    let englishName, iso639_1, name: String?

    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
        case iso639_1 = "iso_639_1"
        case name
    }
}
