//
//  MovieModedl.swift
//  MovieApp
//
//  Created by Kerem Saltık on 13.10.2025.
//

import Foundation


struct MovieResponse: Codable{
    let page: Int
    let results: [MovieModel]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}


struct MovieModel: Codable, Identifiable, Hashable, DisplayableMedia{
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String?
    let voteAverage: Double
    let voteCount: Int
    let popularity: Double
    let genreIds: [Int]
    let originalLanguage: String?
    let originalTitle: String?
    let adult: Bool
    let video: Bool
    
    
    enum CodingKeys: String, CodingKey {
            case id, title, overview, popularity, adult, video
            case posterPath = "poster_path"
            case backdropPath = "backdrop_path"
            case releaseDate = "release_date"
            case voteAverage = "vote_average"
            case voteCount = "vote_count"
            case genreIds = "genre_ids"
            case originalLanguage = "original_language"
            case originalTitle = "original_title"
        }
    
    var posterURL: URL?{
        guard let posterPath = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
    }
}
